# 📸 تحديث البروفايل مع رفع الصورة

## ✅ التغييرات المطبقة

### 1. **عرض صورة البروفايل من API** 

#### ProfileScreen (عرض البروفايل)
```dart
// قبل:
CircleAvatar(
  backgroundImage: NetworkImage(
    'https://ui-avatars.com/api/?name=${profile.name}&background=random',
  ),
)

// بعد:
CircleAvatar(
  backgroundImage: NetworkImage(
    profile.avatar != null && profile.avatar!.isNotEmpty
        ? profile.avatar!                  // ← من API
        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(profile.name)}&background=random',
  ),
)
```

---

### 2. **API Update - Multipart Form Data**

#### ProfileRemoteDataSource
```dart
@POST(ApiEndpoints.profileUpdate)
@MultiPart()
Future<BaseResponse<DataWrapper<UserProfile>>> updateProfile({
  @Part(name: 'name') String? name,
  @Part(name: 'avatar') MultipartFile? avatar,
});
```

- ✅ تم تغيير من `@Body()` إلى `@MultiPart()`
- ✅ دعم رفع الصور مع الاسم
- ✅ كلا المعاملين اختياري

---

### 3. **Repository - معالجة الصور**

#### ProfileRepositoryImpl
```dart
@override
Future<UserProfile> updateProfile(String? name, [String? avatarPath]) async {
  try {
    MultipartFile? avatarFile;
    if (avatarPath != null && avatarPath.isNotEmpty) {
      avatarFile = await MultipartFile.fromFile(avatarPath);
    }
    
    final response = await _remoteDataSource.updateProfile(
      name: name,
      avatar: avatarFile,
    );
    
    return response.data!.data;
  } catch (e) {
    throw ErrorHandler.handle(e);
  }
}
```

- ✅ تحويل مسار الصورة إلى `MultipartFile`
- ✅ معالجة الأخطاء
- ✅ دعم تحديث الاسم فقط أو الصورة فقط أو كليهما

---

### 4. **Edit Profile Screen - واجهة رفع الصورة**

#### الميزات الجديدة:

**أ) اختيار الصورة من المعرض:**
```dart
Future<void> _pickImage() async {
  final XFile? image = await _picker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 1024,
    maxHeight: 1024,
    imageQuality: 85,  // ← ضغط الصورة
  );
  
  if (image != null) {
    setState(() {
      _selectedImage = File(image.path);
    });
  }
}
```

**ب) عرض الصورة المحددة:**
```dart
CircleAvatar(
  radius: 60,
  backgroundImage: _selectedImage != null
      ? FileImage(_selectedImage!)           // ← صورة محددة من الجهاز
      : NetworkImage(profile.avatar ?? fallback) as ImageProvider,
)
```

**ج) زر كاميرا أنيق:**
```dart
Positioned(
  bottom: 0,
  right: 0,
  child: GestureDetector(
    onTap: _pickImage,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
          ),
        ],
      ),
      child: const Icon(
        Icons.camera_alt_rounded,
        color: Colors.white,
      ),
    ),
  ),
)
```

**د) رفع الملف:**
```dart
Future<void> _saveProfile() async {
  setState(() => _isUploading = true);
  
  await ref.read(userProfileProvider.notifier).updateProfile(
    _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : null,
    _selectedImage?.path,  // ← مسار الصورة
  );
}
```

---

### 5. **Pipeline الكامل**

```
المستخدم يختار صورة
         ↓
   ImagePicker يفتح المعرض
         ↓
  File يُحفظ في _selectedImage
         ↓
   UI يعرض الصورة مباشرة
         ↓
  عند الحفظ: File.path يُرسل للـ provider
         ↓
   Provider → UseCase → Repository
         ↓
  Repository يحول path إلى MultipartFile
         ↓
   DataSource يرسل multipart/form-data للباك إند
         ↓
  الباك إند يحفظ الصورة ويعيد profile محدث
         ↓
   Provider يحدث الحالة
         ↓
  UI يعرض الصورة الجديدة من API
```

---

## 📦 Dependencies

```yaml
dependencies:
  image_picker: ^1.2.1  # ✅ موجود بالفعل
  dio: ^5.4.1          # ✅ لـ MultipartFile
```

---

## 🧪 الاختبار

### 1. اختبار عرض الصورة:
- ✅ إذا كان `profile.avatar` موجود، يعرض الصورة من API
- ✅ إذا لم يكن موجود، يعرض fallback من ui-avatars

### 2. اختبار اختيار الصورة:
```
1. فتح Edit Profile
2. الضغط على زر الكاميرا
3. اختيار صورة من المعرض
4. يجب أن تظهر الصورة مباشرة في CircleAvatar
```

### 3. اختبار رفع الصورة:
```
1. اختيار صورة جديدة
2. الضغط على "Save Changes"
3. انتظار التحميل (loading indicator)
4. رؤية SnackBar "Profile updated successfully"
5. الرجوع للصفحة الرئيسية
6. التحقق من ظهور الصورة الجديدة
```

### 4. اختبار تحديث الاسم فقط:
```
1. تغيير الاسم بدون اختيار صورة
2. الحفظ
3. يجب أن يتم التحديث بنجاح
```

### 5. الحالات الخاصة:
- ✅ رفع صورة فقط (name = null)
- ✅ رفع اسم فقط (avatar = null)
- ✅ رفع كليهما
- ✅ معالجة الأخطاء (network error, file too large, etc.)

---

## 🎨 UI/UX

### التحسينات:
1. ✅ **Hero Animation** - انتقال سلس للصورة
2. ✅ **Gradient Border** - حدود ملونة حول الصورة
3. ✅ **Camera Button** - زر أنيق بظل
4. ✅ **Instant Preview** - عرض الصورة مباشرة بعد الاختيار
5. ✅ **Loading State** - CircularProgressIndicator أثناء الرفع
6. ✅ **Error Handling** - SnackBar للنجاح والفشل

---

## 📝 API Endpoint

```
POST /api/student/profile/update
Content-Type: multipart/form-data

Parameters:
- name: String (optional)     // اسم المستخدم
- avatar: File (optional)     // صورة البروفايل
```

**مثال Request:**
```
POST /api/student/profile/update
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary

------WebKitFormBoundary
Content-Disposition: form-data; name="name"

Bayan Mansour
------WebKitFormBoundary
Content-Disposition: form-data; name="avatar"; filename="profile.jpg"
Content-Type: image/jpeg

<binary data>
------WebKitFormBoundary--
```

**Response:**
```json
{
  "success": true,
  "message": "Profile updated successfully",
  "data": {
    "data": {
      "id": 8,
      "name": "Bayan Mansour",
      "email": "bayan@example.com",
      "avatar": "https://api.example.com/storage/avatars/123.jpg"
    }
  }
}
```

---

## ⚠️ ملاحظات مهمة

1. **حجم الصورة**: تم ضبط `maxWidth` و `maxHeight` إلى 1024 px
2. **الجودة**: `imageQuality: 85` لتقليل حجم الملف
3. **Uri.encodeComponent**: لتجنب مشاكل الأحرف الخاصة في URL
4. **Null Safety**: جميع المعاملات nullable للمرونة
5. **Error Handling**: معالجة شاملة للأخطاء في كل طبقة

---

## 🎯 الخلاصة

| **الميزة** | **الحالة** |
|------------|------------|
| عرض avatar من API | ✅ مطبق |
| رفع الصورة multipart/form-data | ✅ مطبق |
| اختيار الصورة من المعرض | ✅ مطبق |
| عرض فوري للصورة المحددة | ✅ مطبق |
| تحديث الاسم والصورة معاً | ✅ مطبق |
| معالجة الأخطاء | ✅ مطبق |
| UI/UX محسن | ✅ مطبق |

**كل شيء جاهز! 🎉**
