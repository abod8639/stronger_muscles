#!/bin/bash

# ============================================================
#   Flutter Clean Architecture - Feature Generator
#   يولّد هيكل الفيتشر داخل lib/features تلقائياً
# ============================================================

# ── الألوان ──────────────────────────────────────────────────
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
RESET='\033[0m'

# ── شعار الترحيب ─────────────────────────────────────────────
echo ""
echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}${BOLD}║      Flutter Clean Architecture Generator 🚀         ║${RESET}"
echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════════════════╝${RESET}"
echo ""

# ── طلب اسم الفيتشر ──────────────────────────────────────────
read -p "$(echo -e ${YELLOW}${BOLD}"أدخل اسم الفيتشر الجديد (مثال: product): "${RESET})" FEATURE_RAW

# ── التحقق من الإدخال ────────────────────────────────────────
if [[ -z "$FEATURE_RAW" ]]; then
  echo -e "${RED}❌ لم تُدخل اسماً! يرجى إعادة التشغيل.${RESET}"
  exit 1
fi

# تحويل الاسم إلى lowercase وإزالة المسافات
FEATURE=$(echo "$FEATURE_RAW" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')

# ── اسم الكلاس (PascalCase) ───────────────────────────────────
to_pascal() {
  echo "$1" | awk -F'_' '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2); print}' OFS=''
}
CLASS=$(to_pascal "$FEATURE")

# ── تحديد المسار ─────────────────────────────────────────────
BASE_PATH="lib/features/${FEATURE}"

# ── التحقق من وجود الفيتشر مسبقاً ───────────────────────────
if [[ -d "$BASE_PATH" ]]; then
  echo -e "${RED}⚠️  الفيتشر '${FEATURE}' موجود بالفعل في: ${BASE_PATH}${RESET}"
  echo -e "${YELLOW}هل تريد الكتابة فوقه؟ (yes/no):${RESET} \c"
  read OVERWRITE
  if [[ "$OVERWRITE" != "yes" ]]; then
    echo -e "${CYAN}تم الإلغاء. لم يُعدَّل أي شيء.${RESET}"
    exit 0
  fi
fi

echo ""
echo -e "${CYAN}⚙️  جاري إنشاء فيتشر: ${BOLD}${CLASS}${RESET}"
echo ""

# ═══════════════════════════════════════════════════════════════
#  دالة مساعدة: إنشاء ملف مع محتواه
# ═══════════════════════════════════════════════════════════════
write_file() {
  local FILE_PATH="$1"
  local CONTENT="$2"
  mkdir -p "$(dirname "$FILE_PATH")"
  echo "$CONTENT" > "$FILE_PATH"
  echo -e "  ${GREEN}✔${RESET} $FILE_PATH"
}

# ══════════════════════════════════════════════════════════════
#  1. DOMAIN LAYER
# ══════════════════════════════════════════════════════════════
echo -e "${BOLD}📂 Domain Layer${RESET}"

# Entity
write_file "${BASE_PATH}/domain/entities/${FEATURE}_entity.dart" \
"class ${CLASS}Entity {
  final String id;
  final String name;

  const ${CLASS}Entity({
    required this.id,
    required this.name,
  });
}"

# Repository (abstract)
write_file "${BASE_PATH}/domain/repositories/${FEATURE}_repository.dart" \
"import '../entities/${FEATURE}_entity.dart';

abstract class ${CLASS}Repository {
  Future<List<${CLASS}Entity>> getAll${CLASS}s();
  Future<${CLASS}Entity> get${CLASS}ById(String id);
  Future<void> create${CLASS}(${CLASS}Entity entity);
}"

# Usecases
write_file "${BASE_PATH}/domain/usecases/get_${FEATURE}s_usecase.dart" \
"import '../entities/${FEATURE}_entity.dart';
import '../repositories/${FEATURE}_repository.dart';

class Get${CLASS}sUsecase {
  final ${CLASS}Repository repository;

  Get${CLASS}sUsecase(this.repository);

  Future<List<${CLASS}Entity>> call() => repository.getAll${CLASS}s();
}"

write_file "${BASE_PATH}/domain/usecases/get_${FEATURE}_by_id_usecase.dart" \
"import '../entities/${FEATURE}_entity.dart';
import '../repositories/${FEATURE}_repository.dart';

class Get${CLASS}ByIdUsecase {
  final ${CLASS}Repository repository;

  Get${CLASS}ByIdUsecase(this.repository);

  Future<${CLASS}Entity> call(String id) => repository.get${CLASS}ById(id);
}"

write_file "${BASE_PATH}/domain/usecases/create_${FEATURE}_usecase.dart" \
"import '../entities/${FEATURE}_entity.dart';
import '../repositories/${FEATURE}_repository.dart';

class Create${CLASS}Usecase {
  final ${CLASS}Repository repository;

  Create${CLASS}Usecase(this.repository);

  Future<void> call(${CLASS}Entity entity) => repository.create${CLASS}(entity);
}"

# ══════════════════════════════════════════════════════════════
#  2. DATA LAYER
# ══════════════════════════════════════════════════════════════
echo ""
echo -e "${BOLD}📂 Data Layer${RESET}"

# Model
write_file "${BASE_PATH}/data/models/${FEATURE}_model.dart" \
"import '../../domain/entities/${FEATURE}_entity.dart';

class ${CLASS}Model extends ${CLASS}Entity {
  const ${CLASS}Model({
    required super.id,
    required super.name,
  });

  factory ${CLASS}Model.fromJson(Map<String, dynamic> json) {
    return ${CLASS}Model(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}"

# Remote Datasource
write_file "${BASE_PATH}/data/datasources/${FEATURE}_remote_datasource.dart" \
"import '../models/${FEATURE}_model.dart';

abstract class ${CLASS}RemoteDatasource {
  Future<List<${CLASS}Model>> getAll${CLASS}s();
  Future<${CLASS}Model> get${CLASS}ById(String id);
  Future<void> create${CLASS}(${CLASS}Model model);
}

class ${CLASS}RemoteDatasourceImpl implements ${CLASS}RemoteDatasource {
  // TODO: inject Dio / http client

  @override
  Future<List<${CLASS}Model>> getAll${CLASS}s() async {
    // TODO: implement API call
    throw UnimplementedError();
  }

  @override
  Future<${CLASS}Model> get${CLASS}ById(String id) async {
    // TODO: implement API call
    throw UnimplementedError();
  }

  @override
  Future<void> create${CLASS}(${CLASS}Model model) async {
    // TODO: implement API call
    throw UnimplementedError();
  }
}"

# Local Datasource
write_file "${BASE_PATH}/data/datasources/${FEATURE}_local_datasource.dart" \
"import '../models/${FEATURE}_model.dart';

abstract class ${CLASS}LocalDatasource {
  Future<List<${CLASS}Model>> getCached${CLASS}s();
  Future<void> cache${CLASS}s(List<${CLASS}Model> models);
}

class ${CLASS}LocalDatasourceImpl implements ${CLASS}LocalDatasource {
  // TODO: inject SharedPreferences / Hive / Isar

  @override
  Future<List<${CLASS}Model>> getCached${CLASS}s() async {
    // TODO: implement local read
    throw UnimplementedError();
  }

  @override
  Future<void> cache${CLASS}s(List<${CLASS}Model> models) async {
    // TODO: implement local write
    throw UnimplementedError();
  }
}"

# Repository Impl
write_file "${BASE_PATH}/data/repositories/${FEATURE}_repository_impl.dart" \
"import '../../domain/entities/${FEATURE}_entity.dart';
import '../../domain/repositories/${FEATURE}_repository.dart';
import '../datasources/${FEATURE}_remote_datasource.dart';
import '../datasources/${FEATURE}_local_datasource.dart';
import '../models/${FEATURE}_model.dart';

class ${CLASS}RepositoryImpl implements ${CLASS}Repository {
  final ${CLASS}RemoteDatasource remoteDatasource;
  final ${CLASS}LocalDatasource localDatasource;

  ${CLASS}RepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<List<${CLASS}Entity>> getAll${CLASS}s() async {
    final models = await remoteDatasource.getAll${CLASS}s();
    await localDatasource.cache${CLASS}s(models);
    return models;
  }

  @override
  Future<${CLASS}Entity> get${CLASS}ById(String id) =>
      remoteDatasource.get${CLASS}ById(id);

  @override
  Future<void> create${CLASS}(${CLASS}Entity entity) =>
      remoteDatasource.create${CLASS}(${CLASS}Model(id: entity.id, name: entity.name));
}"

# ══════════════════════════════════════════════════════════════
#  3. PRESENTATION LAYER
# ══════════════════════════════════════════════════════════════
echo ""
echo -e "${BOLD}📂 Presentation Layer${RESET}"

# Page
write_file "${BASE_PATH}/presentation/pages/${FEATURE}s_page.dart" \
"import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/${FEATURE}_controller.dart';
import '../widgets/${FEATURE}_list.dart';

class ${CLASS}sPage extends GetView<${CLASS}Controller> {
  const ${CLASS}sPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('${CLASS}s')),
      body: const ${CLASS}List(),
    );
  }
}"

# Widgets
write_file "${BASE_PATH}/presentation/widgets/${FEATURE}_card.dart" \
"import 'package:flutter/material.dart';
import '../../domain/entities/${FEATURE}_entity.dart';

class ${CLASS}Card extends StatelessWidget {
  final ${CLASS}Entity entity;

  const ${CLASS}Card({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(entity.name),
        subtitle: Text(entity.id),
      ),
    );
  }
}"

write_file "${BASE_PATH}/presentation/widgets/${FEATURE}_list.dart" \
"import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/${FEATURE}_controller.dart';
import '${FEATURE}_card.dart';

class ${CLASS}List extends GetView<${CLASS}Controller> {
  const ${CLASS}List({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        itemCount: controller.items.length,
        itemBuilder: (_, i) => ${CLASS}Card(entity: controller.items[i]),
      );
    });
  }
}"

write_file "${BASE_PATH}/presentation/widgets/${FEATURE}_search_bar.dart" \
"import 'package:flutter/material.dart';

class ${CLASS}SearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const ${CLASS}SearchBar({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: const InputDecoration(
        hintText: 'Search...',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}"

# Controller
write_file "${BASE_PATH}/presentation/controllers/${FEATURE}_controller.dart" \
"import 'package:get/get.dart';
import '../../domain/entities/${FEATURE}_entity.dart';
import '../../domain/usecases/get_${FEATURE}s_usecase.dart';
import '../../domain/usecases/get_${FEATURE}_by_id_usecase.dart';
import '../../domain/usecases/create_${FEATURE}_usecase.dart';

class ${CLASS}Controller extends GetxController {
  final Get${CLASS}sUsecase get${CLASS}sUsecase;
  final Get${CLASS}ByIdUsecase get${CLASS}ByIdUsecase;
  final Create${CLASS}Usecase create${CLASS}Usecase;

  ${CLASS}Controller({
    required this.get${CLASS}sUsecase,
    required this.get${CLASS}ByIdUsecase,
    required this.create${CLASS}Usecase,
  });

  final RxList<${CLASS}Entity> items = <${CLASS}Entity>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    isLoading.value = true;
    items.value = await get${CLASS}sUsecase();
    isLoading.value = false;
  }
}"

# Binding
write_file "${BASE_PATH}/presentation/controllers/${FEATURE}_binding.dart" \
"import 'package:get/get.dart';
import '../../data/datasources/${FEATURE}_remote_datasource.dart';
import '../../data/datasources/${FEATURE}_local_datasource.dart';
import '../../data/repositories/${FEATURE}_repository_impl.dart';
import '../../domain/usecases/get_${FEATURE}s_usecase.dart';
import '../../domain/usecases/get_${FEATURE}_by_id_usecase.dart';
import '../../domain/usecases/create_${FEATURE}_usecase.dart';
import '${FEATURE}_controller.dart';

class ${CLASS}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${CLASS}RemoteDatasource>(() => ${CLASS}RemoteDatasourceImpl());
    Get.lazyPut<${CLASS}LocalDatasource>(() => ${CLASS}LocalDatasourceImpl());
    Get.lazyPut(() => ${CLASS}RepositoryImpl(
          remoteDatasource: Get.find(),
          localDatasource: Get.find(),
        ));
    Get.lazyPut(() => Get${CLASS}sUsecase(Get.find()));
    Get.lazyPut(() => Get${CLASS}ByIdUsecase(Get.find()));
    Get.lazyPut(() => Create${CLASS}Usecase(Get.find()));
    Get.lazyPut(() => ${CLASS}Controller(
          get${CLASS}sUsecase: Get.find(),
          get${CLASS}ByIdUsecase: Get.find(),
          create${CLASS}Usecase: Get.find(),
        ));
  }
}"

# ══════════════════════════════════════════════════════════════
#  ملخص نهائي
# ══════════════════════════════════════════════════════════════
echo ""
echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}${BOLD}║  ✅  تم إنشاء الفيتشر بنجاح!                        ║${RESET}"
echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════════════════╝${RESET}"
echo ""
echo -e "${BOLD}📁 الهيكل المُنشأ:${RESET}"
find "$BASE_PATH" -type f | sort | sed 's|^|   |'
echo ""
echo -e "${YELLOW}💡 الخطوة التالية: سجّل الـ Binding في AppPages:${RESET}"
echo -e "   ${CYAN}GetPage(name: '/${FEATURE}s', page: () => ${CLASS}sPage(), binding: ${CLASS}Binding())${RESET}"
echo ""
