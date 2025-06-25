<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <link rel="icon" type="image/png" href="./image/logo.png" />
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>البروفايل</title>

  <!-- خطوط -->
  <link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@400;700&display=swap" rel="stylesheet">
  <style>
    :root {
      --main-color: #0077b6;
      --background:  #f4f6f8;
    }
    body{margin:0;padding:0;font-family:'Tajawal',sans-serif;background:var(--background);color:#333}
    header{background:var(--main-color);color:#fff;text-align:center;padding:1rem 0}
    main{max-width:600px;margin:2rem auto;padding:2rem;background:#fff;border-radius:12px;box-shadow:0 2px 6px rgba(0,0,0,.08)}
    h2{margin-top:0;color:var(--main-color);text-align:center}
    label{display:block;margin:.75rem 0 .25rem}
    input{width:100%;padding:.6rem;border:1px solid #ccc;border-radius:8px}
    button{margin-top:1rem;padding:.6rem 1.25rem;border:none;border-radius:8px;background:var(--main-color);color:#fff;cursor:pointer}
    button:hover{opacity:.9}
    .section{margin-top:2rem;border-top:1px solid #eee;padding-top:1.5rem}
    .note{font-size:.85rem;color:#e63946;margin-top:.5rem}
  </style>

  <!-- Firebase -->
  <script src="https://www.gstatic.com/firebasejs/10.12.0/firebase-app-compat.js"></script>
  <script src="https://www.gstatic.com/firebasejs/10.12.0/firebase-auth-compat.js"></script>
  <script src="https://www.gstatic.com/firebasejs/10.12.0/firebase-firestore-compat.js"></script>
</head>
<body>
  <header><h1>ملفك الشخصي</h1></header>

  <main>
    <h2>بيانات الحساب</h2>

    <!-- إظهار الإيميل الحالي -->
    <p><strong>الإيميل الحالي:</strong> <span id="current-email">...جاري التحميل</span></p>

    <!-- ====== تعديل الإيميل ====== -->
    <div class="section">
      <h3>تعديل الإيميل</h3>
      <label for="new-email">الإيميل الجديد</label>
      <input id="new-email" type="email" placeholder="you@example.com">
      <button id="update-email">حفظ الإيميل</button>
      <p class="note">قد يُطلب منك تسجيل الدخول مجددًا.</p>
    </div>

    <!-- ====== تغيير كلمة السر ====== -->
    <div class="section">
      <h3>تغيير كلمة السر</h3>
      <label for="new-pass">كلمة السر الجديدة</label>
      <input id="new-pass" type="password" placeholder="*******">
      <label for="confirm-pass">تأكيد كلمة السر</label>
      <input id="confirm-pass" type="password" placeholder="*******">
      <button id="update-pass">حفظ كلمة السر</button>
      <p class="note">يجب أن تكون 6 حروف أو أكثر.</p>
    </div>

    <!-- زر خروج -->
    <div class="section">
      <button id="logout" style="background:#e63946">تسجيل الخروج</button>
    </div>
  </main>

  <script>
    /* 🔧 بيانات مشروعك لو اختلفت */
    const firebaseConfig = {
      apiKey: "AIzaSyDxcQOSrEHT5HNpDP7_hbSGl4cj4yXK1ZI",
      authDomain: "mk7t-e7a37.firebaseapp.com",
      projectId: "mk7t-e7a37",
      storageBucket: "mk7t-e7a37.firebasestorage.app",
      messagingSenderId: "574578397300",
      appId: "1:574578397300:web:fe79fccd0a01f0b8ac4121"
    };
    firebase.initializeApp(firebaseConfig);
    const db = firebase.firestore();

    const currentEmailEl = document.getElementById('current-email');
    const newEmailInput  = document.getElementById('new-email');
    const newPassInput   = document.getElementById('new-pass');
    const confirmPassInp = document.getElementById('confirm-pass');

    /* تحقّق من تسجيل الدخول */
    let currentUser = null;
    firebase.auth().onAuthStateChanged(user => {
      if (!user){
        window.location.href = "login.html";   // 🔧 مسار صفحة تسجيل الدخول
        return;
      }
      currentUser = user;
      currentEmailEl.textContent = user.email;
    });

    /* ===== تحديث الإيميل ===== */
    document.getElementById('update-email').onclick = async () => {
      const newEmail = newEmailInput.value.trim();
      if (!newEmail) { alert("أدخل الإيميل الجديد"); return; }

      try {
        await currentUser.updateEmail(newEmail);
        /* لو بتخزن الإيميل في Firestore كمان */
        await db.collection('users').doc(currentUser.uid).update({ email: newEmail }); // 🔧 اسم الكوليكشن لو مختلف
        alert("تم تحديث الإيميل بنجاح");
        currentEmailEl.textContent = newEmail;
        newEmailInput.value = "";
      } catch(err){
        console.error(err);
        alert("فشل تحديث الإيميل: " + err.message);
      }
    };

    /* ===== تحديث كلمة السر ===== */
    document.getElementById('update-pass').onclick = async () => {
      const pass = newPassInput.value;
      const confirm = confirmPassInp.value;
      if (pass.length < 6){ alert("كلمة السر قصيرة جدًا"); return; }
      if (pass !== confirm){ alert("كلمة السر غير متطابقة"); return; }

      try {
        await currentUser.updatePassword(pass);
        alert("تم تحديث كلمة السر بنجاح");
        newPassInput.value = confirmPassInp.value = "";
      } catch(err){
        console.error(err);
        alert("فشل تحديث كلمة السر: " + err.message);
      }
    };

    /* ===== تسجيل الخروج ===== */
    document.getElementById('logout').onclick = () => {
      firebase.auth().signOut().then(()=>{
        window.location.href = "login.html";   // 🔧
      });
    };
  </script>
</body>
</html>
