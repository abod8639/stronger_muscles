import 'dart:async';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/config/api_config.dart';

final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  final service = WebSocketService();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});

class WebSocketService {
  PusherChannelsClient? _client;
  final Map<String, PublicChannel> _subscribedChannels = {};
  final List<StreamSubscription> _lifecycleSubscriptions = [];
  bool _isConnecting = false;

  WebSocketService() {
    _initClient();
    unawaited(connect());
  }

  PusherChannelsClient get client {
    if (_client == null) {
      _initClient();
    }
    return _client!;
  }

  void _initClient() {
    _cleanupLifecycleSubscriptions();

    final options = PusherChannelsOptions.fromHost(
      scheme: ApiConfig.wsScheme,
      host: ApiConfig.wsHost,
      port: ApiConfig.wsPort,
      key: ApiConfig.wsKey,
    );

    _client = PusherChannelsClient.websocket(
      options: options,
      connectionErrorHandler: (exception, trace, refresh) async {
        debugPrint('[WebSocket] Connection error: $exception');
        await Future.delayed(const Duration(seconds: 3));
        refresh();
      },
    );

    _lifecycleSubscriptions.add(
      _client!.onConnectionEstablished.listen((_) {
        debugPrint(
          '[WebSocket] Connected to Reverb (${ApiConfig.wsHost}:${ApiConfig.wsPort})',
        );
        for (final channel in _subscribedChannels.values) {
          channel.subscribe();
        }
      }),
    );
  }

  Future<void> connect() async {
    if (_isConnecting) return;
    try {
      _isConnecting = true;
      if (_client == null) {
        _initClient();
      }
      await _client?.connect();
    } catch (e) {
      debugPrint('[WebSocket] Error connecting: $e');
    } finally {
      _isConnecting = false;
    }
  }

  /// Subscribe to any public channel by name.
  PublicChannel subscribeToChannel(String channelName) {
    final cleanName = channelName.trim();
    if (_subscribedChannels.containsKey(cleanName)) {
      final existing = _subscribedChannels[cleanName]!;
      existing.subscribe();
      return existing;
    }

    final channel = client.publicChannel(cleanName);
    _subscribedChannels[cleanName] = channel;
    channel.subscribe();
    unawaited(connect());
    return channel;
  }

  /// Subscribe to a specific ticket channel: support.ticket.{ticketId}
  PublicChannel subscribeToTicket(String ticketId) {
    final cleanId = ticketId.trim();
    return subscribeToChannel('support.ticket.$cleanId');
  }

  /// Unsubscribe from a ticket channel
  void unsubscribeFromTicket(String ticketId) {
    final cleanId = ticketId.trim();
    unsubscribeFromChannel('support.ticket.$cleanId');
  }

  /// Unsubscribe from any channel by name
  void unsubscribeFromChannel(String channelName) {
    final cleanName = channelName.trim();
    final channel = _subscribedChannels.remove(cleanName);
    channel?.unsubscribe();
  }

  void _cleanupLifecycleSubscriptions() {
    for (final sub in _lifecycleSubscriptions) {
      sub.cancel();
    }
    _lifecycleSubscriptions.clear();
  }

  void dispose() {
    _cleanupLifecycleSubscriptions();

    for (final channel in _subscribedChannels.values) {
      channel.unsubscribe();
    }
    _subscribedChannels.clear();

    _client?.disconnect();
    _client = null;
  }
}
