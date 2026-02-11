# هيكلية المشروع وأنماط التصميم (Architecture & Design Patterns) - مشروع Yuna

هذا المستند يشرح بالتفصيل المنهجية المتبعة في بناء تطبيق "Yuna"، والتقنيات المستخدمة، وكيفية الإجابة على الأسئلة المتعلقة بها في المقابلات الوظيفية.

---

## 🏗️ Clean Architecture (الهيكلية النظيفة)

تم بناء المشروع باتباع مبادئ **Clean Architecture**، والتي تهدف إلى فصل المسؤوليات (Separation of Concerns) لجعل الكود قابلاً للاختبار (Testable)، قابلاً للصيانة (Maintainable)، ومستقلاً عن التغييرات الخارجية (سواء كانت UI أو API).

يتكون المشروع من ثلاث طبقات رئيسية:

### 1. طبقة البيانات (Data Layer) 🌍

هي الطبقة المسؤولة عن التعامل مع العالم الخارجي (APIs, Local Database). لا تعرف الـ UI أي شيء عن تفاصيلها.

- **المكونات في مشروعنا:**
  - **Data Models**: نماذج البيانات التي تمثل شكل الـ JSON القادم من السيرفر.
    - _مثال_: `SubCategoryModel` (يحتوي على `fromJson`, `toJson`).
    - _التقنية_: `freezed` و `json_serializable`.
  - **Data Sources (Remote/Local)**: المسؤولة عن الاتصال المباشر.
    - _مثال_: `ProfileRemoteDataSource` (يستخدم `Retrofit` لطلب `GET /student/profile`).
  - **Repositories Implementation**: التنفيذ الفعلي للعقود (Interfaces) الموجودة في الـ Domain. هنا يتم اتخاذ القرار: هل نجلب البيانات من الكاش أم من السيرفر؟
    - _مثال_: `ProfileRepositoryImpl`.

### 2. طبقة النطاق (Domain Layer) 🧠

هي "قلب" التطبيق. تحتوي على قواعد العمل (Business Logic) وتكون **مستقلة تماماً** (Pure Dart)، أي لا تعتمد على Flutter ولا على أي مكتبة خارجية (مثل Dio أو HTTP).

- **المكونات في مشروعنا:**
  - **Entities**: كائنات البيانات الصافية التي يستخدمها التطبيق داخلياً.
    - _مثال_: `UserProfile` (قد يكون مختلفاً قليلاً عن الـ Model، لكننا أحياناً نستخدم نفس الكلاس للتسهيل في المشاريع المتوسطة).
  - **Repositories Interfaces**: عقود (Abstract Classes) تحدد "ماذا" نريد، دون تحديد "كيف".
    - _مثال_: `abstract class ProfileRepository { Future<UserProfile> getProfile(); }`.
  - **UseCases**: يمثل كل كلاس "فعل" أو "مهمة" واحدة يقوم بها المستخدم. هذا يطبق مبدأ _Single Responsibility Principle_.
    - _مثال_: `GetProfileUseCase`. يقوم فقط بمناداة الـ Repository.

### 3. طبقة العرض (Presentation Layer) 🎨

هي الطبقة التي يراها المستخدم.

- **المكونات في مشروعنا:**
  - **Screens/Widgets**: واجهة المستخدم.
    - _مثال_: `ProfileScreen`، `CoursesScreen`.
  - **State Management (Providers)**: حلقة الوصل بين الـ UI والـ Domain.
    - _التقنية_: `Riverpod`.
    - _مثال_: `userProfileProvider` يطلب البيانات من `GetProfileUseCase` ويعطي حالة (Loading, Data, Error) للـ Screen.

---

## 🛠️ Design Patterns (أنماط التصميم المطبقة)

### 1. Repository Pattern

- **الشرح**: نمط يفصل منطق الوصول للبيانات عن منطق العمل. الـ UseCase لا يعرف هل البيانات قادمة من API أم Firebase أم Cache.
- **في مشروعنا**: `GetProfileUseCase` يتحدث مع `ProfileRepository` (Interface) فقط. `ProfileRepositoryImpl` هو من يعرف التفاصيل.
- **الفائدة**: سهولة تغيير الـ Backend لاحقاً دون كسر التطبيق، وسهولة كتابة Unit Tests.

### 2. Dependency Injection (DI)

- **الشرح**: توفير الكائنات التي يحتاجها الكلاس من الخارج بدلاً من إنشائها داخله.
- **في مشروعنا**: نستخدم مكتبة **`get_it`** في ملف `service_locator.dart`.

#### أنواع تسجيل الاعتماديات (Registration Types) - سؤال مقابلات مهم 🌟

عند استخدام `GetIt`، لدينا ثلاث طرق رئيسية لتسجيل الكلاسات، والفرق بينها جوهري:

1. **Factory (`registerFactory`)**:
    - **المفهوم**: "مصنع" ينشئ **نسخة جديدة كلياً** في كل مرة تطلب فيها الكلاس.
    - **متى يستخدم؟**: للكلاسات التي تحمل حالة مؤقتة يجب تصفيرها عند الخروج وظيفة (Function scope) أو شاشة (Screen scope).
    - _مثال_: `sl.registerFactory(() => AuthUseCase(sl()));` (غالباً الـ UseCases والـ Cubits/Blocs يتم تسجيلها كـ Factory).

2. **Singleton (`registerSingleton`)**:
    - **المفهوم**: يتم إنشاء النسخة **فوراً** لحظة تشغيل التطبيق (عند استدعاء دالة `setupLocator`). وتبقى نفس النسخة حية طوال حياة التطبيق.
    - **متى يستخدم؟**: نادراً ما نستخدمه إلا إذا كنا متأكدين 100% أننا نحتاج هذا الكلاس جاهزاً قبل أي تفاعل.
    - _عيوبه_: يبطئ فتح التطبيق (Startup Time) لأنه ينشئ كل شيء دفعة واحدة، حتى لو لم يستخدمه المستخدم.

3. **Lazy Singleton (`registerLazySingleton`)**:
    - **المفهوم**: هو "Singleton كسول". لا يتم إنشاء النسخة عند تشغيل التطبيق، بل ننتظر **أول مرة** يطلب فيها أحد هذا الكلاس، فنقوم بإنشائه، ومن ثم نحتفظ به ونعيده هو نفسه في المرات القادمة.
    - **متى يستخدم؟**: هذا هو النوع الأكثر استخداماً ("Standard") في هيكلية المشروع. نستخدمه للـ Services، Repositories، و DataSources.
    - _مثال_: `sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));`. نحن نريد Repository واحد فقط لكل التطبيق، ولكن لا نريد إنشاءه إلا عندما نحتاجه.

> **الخلاصة المختصرة**:
>
> - **Factory**: New Object every time (للحالات المتغيرة).
> - **Singleton**: Created on App Start (دائماً موجود، قد يبطئ الإطلاق).
> - **Lazy Singleton**: Created on First Request (الأفضل للموارد المشتركة).

### 4. Adapter / Wrapper Pattern

- **الشرح**: تغليف كلاس أو بيانات لتوحيد التعامل معها.
- **في مشروعنا**:
  - `DataWrapper<T>`: قمنا بإنشائه لأن الـ API يعيد البيانات داخل مفتاح `data` متداخل (`data: { data: ... }`). الـ Wrapper قام بحل المشكلة وتوحيد الشكل لباقي التطبيق.
  - `BaseResponse<T>`: توحيد شكل الاستجابة (Success, Message, Code).

### 5. Factory Pattern

- **الشرح**: استخدامه لإنشاء الكائنات.
- **في مشروعنا**: يتم استخدامه بكثافة في `fromJson` (بواسطة Freezed) وفي `Retrofit` لإنشاء الـ API Clients.

---

## 🆚 مقارنة تحديث الحالة (State Update): Riverpod vs Bloc

هذا القسم يجيب على السؤال: "كيف نحدث الحالة؟ وما الفرق لو كنا نستخدم Bloc؟"

### 1. في Riverpod (المستخدم في Yuna)

Riverpod يعتمد على مفهوم `Exposure` (كشف الكائن) وتحديثه مباشرة.

- **الآلية**: `Consumer` أو `ref` يقرأ الـ `Notifier` ويستدعي دالة عادية (`Method Call`) لتغيير الحالة.
- **الكود**:

```dart
// 1. تعريف الـ Notifier
class UserNotifier extends Notifier<UserState> {
  @override
  UserState build() => UserState.initial();

  // دالة تحديث عادية
  void updateUser(User user) {
    // state هنا هو متغير محمي (protected) داخل الـ Notifier
    state = UserState.data(user);
  }
}

// 2. الاستخدام في الـ UI
ref.read(userProvider.notifier).updateUser(newUser);
```

### 2. لو كان المشروع يستخدم Bloc

الـ Bloc يعتمد نمط **Event-Driven Architecture**. لا يمكنك تغيير الحالة بـ "دالة"، بل يجب أن "ترسل رسالة/حدث".

- **الآلية**: ترسل `Event` -> الـ Bloc يستقبل الـ Event -> الـ Bloc يصدر `State` جديد (`emit`).
- **الكود**:

```dart
// 1. يجب تعريف الأحداث أولاً
abstract class UserEvent {}
class UpdateUserEvent extends UserEvent {
  final User user;
  UpdateUserEvent(this.user);
}

// 2. تعريف الـ Bloc
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState.initial()) {
    // 3. تسجيل المستمع للحدث
    on<UpdateUserEvent>((event, emit) {
      // المنطق هنا
      emit(UserState.data(event.user));
    });
  }
}

// 4. الاستخدام في الـ UI
context.read<UserBloc>().add(UpdateUserEvent(newUser));
```

### 📋 جدول المقارنة السريع

| وجه المقارنة                 | Riverpod (Notifier)                              | Bloc                                                    |
| :--------------------------- | :----------------------------------------------- | :------------------------------------------------------ |
| **طريقة التغيير**            | استدعاء دالة (`method`) مباشرة.                  | إرسال حدث (`add(Event)`).                               |
| **فلسفة التصميم**            | Direct Manipulation & Reactivity.                | Strict Separation (Input vs Output).                    |
| **كمية الكود (Boilerplate)** | أقل بكثير (فقط كلاس واحد).                       | أكثر (تحتاج ملفات Events, States, Bloc).                |
| **تتبع الأخطاء**             | جيد، ولكن التغيير قد يحدث من أي مكان لديه `ref`. | ممتاز، يمكنك تتبع كل `Event` دخل وكل `State` خرج بوضوح. |

---

## 💼 Interview Corner (ركن المقابلات الوظيفية)

إليك أسئلة شائعة قد تُسأل عنها بناءً على هذا الكود، وإجابات "Senior" نموذجية:

### Q1: لماذا تفضل Clean Architecture في تطبيقات Flutter؟

**الإجابة:** لأنها توفر فصلاً واضحاً للمسؤوليات. في Flutter، من السهل أن يتداخل كود الـ UI مع الـ Logic (Spaghetti Code). الـ Clean Architecture تضمن أن "Business Logic" في الـ Domain Layer مستقل تماماً، مما يسهل كتابة Unit Tests، ويسهل تغيير الـ UI (مثلاً من Mobile إلى Web) أو تغيير الـ Data Source دون إعادة كتابة التطبيق.

### Q2: ما الفرق بين Repository و Data Source؟

**الإجابة:** الـ **Data Source** تتعامل مع مصدر بيانات واحد فقط وبشكل مباشر (مثلاً API Endpoint أو SQL Query).
الـ **Repository** هي المدير؛ يمكنها التعامل مع عدة Data Sources. مثلاً `NewsRepository` قد يطلب الخبر من `LocalDataSource` (Cache) أولاً، وإذا لم يجده، يطلبه من `RemoteDataSource` (API)، ثم يحفظه في الـ Cache. الـ Repository تقرر "من أين" تأتي البيانات.

### Q3: لماذا نستخدم UseCases؟ ألا يمكننا الاتصال بالـ Repository مباشرة من الـ Provider؟

**الإجابة:** في التطبيقات الصغيرة، نعم يمكن. ولكن الـ **UseCases** مفيدة جداً عندما يكبر التطبيق. هي:

1. توثق كل "Feature" في التطبيق ككلاس منفصل (مثل `LoginUseCase`, `LogoutUseCase`).
2. تضمن عدم تكرار الـ Logic. إذا كان هناك منطق معين (مثلاً فلترة الكورسات) نحتاجه في مكانين، نضعه في UseCase.
3. تسهل الـ Testing بشكل كبير.

### Q4: كيف تتعامل مع تغيير البيانات القادمة من الـ API (مثلاً تغيير اسم حقل)؟

**الإجابة:** بفضل Clean Architecture، التغيير يكون محصوراً في **Data Layer** فقط (تحديداً في الـ Model والـ `fromJson`). لا أحتاج لتغيير أي كود في الـ Screen أو الـ UseCase لأنهم يعتمدون على الـ Entity والـ Repository Interface اللذين لم يتغيرا.

### Q5: لماذا استخدمت Riverpod وليس Bloc أو Provider العادي؟

**الإجابة:** (الإجابة تعتمد على التفضيل، ولكن لمشروعنا):
Riverpod هو تطور لـ Provider، يقدم:

1. **Compile-safe**: لا أخطاء `ProviderNotFoundException` أثناء التشغيل.
2. **سهولة دمج الـ Async**: التعامل مع `FutureProvider` و `StreamProvider` ممتاز جداً.
3. **لا يعتمد على الـ Widget Tree**: يمكنني الوصول للـ State من أي مكان (حتى خارج الـ BuildContext أحياناً).

### Q6: كيف قمت بحل مشكلة الـ Nested Data في الـ API لهذا المشروع؟

**الإجابة:** الـ API كان يعيد البيانات مغلفة داخل مفتاح `data` مرتين. قمت بتطبيق نمط **Wrapper Pattern** وأنشأت كلاس `DataWrapper<T>` عام (Generic) باستخدام `Freezed`. هذا سمح لي بفك تغليف البيانات في طبقة الـ Repository وإرجاع البيانات النظيفة للـ UI.

---

## 🔗 المسار العملي للبيانات في Yuna (Data Flow)

عندما يفتح المستخدم صفحة البروفايل:

1. **UI**: `ProfileScreen` تستدعي `ref.watch(userProfileProvider)`.
2. **Provider**: يستدعي `GetProfileUseCase`.
3. **Domain**: الـ UseCase يستدعي `repository.getProfile()`.
4. **Data (Repo)**: `ProfileRepositoryImpl` يستدعي `remoteDataSource.getProfile()`.
5. **Data (Source)**: `Retrofit` يرسل طلب HTTPS `GET` مع التوكن.
6. **Response**: يعود الـ JSON، يقوم `Retrofit` بتحويله لـ `BaseResponse<DataWrapper<UserProfile>>`.
7. **Unwrapping**: يقوم الـ Repository باستخراج `UserProfile` من داخل الـ Wrapper.
8. **Return**: تعود البيانات للكلاسات (Repo -> UseCase -> Provider -> UI).
9. **Render**: تقوم `ProfileScreen` بإعادة الرسم وعرض الاسم والصورة.
