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

  PusherChannelsClient get client {
    if (_client == null) {
      _initClient();
    }
    return _client!;
  }

  void _initClient() {
    final options = PusherChannelsOptions.fromHost(
      scheme: ApiConfig.wsScheme,
      host: ApiConfig.wsHost,
      port: ApiConfig.wsPort,
      key: ApiConfig.wsKey,
    );

    _client = PusherChannelsClient.websocket(
      options: options,
      connectionErrorHandler: (exception, trace, refresh) async {
        debugPrint('WebSocket connection error: $exception');
        refresh();
      },
    );

    _lifecycleSubscriptions.add(
      _client!.onConnectionEstablished.listen((_) {
        debugPrint('WebSocket connected to Reverb (${ApiConfig.wsHost}:${ApiConfig.wsPort})');
        for (final channel in _subscribedChannels.values) {
          channel.subscribeIfNotUnsubscribed();
        }
      }),
    );
  }

  Future<void> connect() async {
    if (_isConnecting) return;
    try {
      _isConnecting = true;
      _initClient();
      await _client?.connect();
    } catch (e) {
      debugPrint('Error connecting WebSocket: $e');
    } finally {
      _isConnecting = false;
    }
  }

  /// Subscribe to a specific ticket channel: support.ticket.{ticketId}
  PublicChannel subscribeToTicket(String ticketId) {
    final channelName = 'support.ticket.$ticketId';
    if (_subscribedChannels.containsKey(channelName)) {
      return _subscribedChannels[channelName]!;
    }

    final channel = client.publicChannel(channelName);
    _subscribedChannels[channelName] = channel;
    channel.subscribeIfNotUnsubscribed();
    connect();
    return channel;
  }

  /// Unsubscribe from a ticket channel
  void unsubscribeFromTicket(String ticketId) {
    final channelName = 'support.ticket.$ticketId';
    final channel = _subscribedChannels.remove(channelName);
    channel?.unsubscribe();
  }

  void dispose() {
    for (final sub in _lifecycleSubscriptions) {
      sub.cancel();
    }
    _lifecycleSubscriptions.clear();

    for (final channel in _subscribedChannels.values) {
      channel.unsubscribe();
    }
    _subscribedChannels.clear();

    _client?.disconnect();
    _client = null;
  }
}
