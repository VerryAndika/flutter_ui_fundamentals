// P9: service worker Firebase Cloud Messaging untuk Flutter Web.
// Menangani notifikasi saat aplikasi di BACKGROUND / tab tidak aktif /
// browser masih berjalan tetapi halaman tertutup.
importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyDP6OOU5reuuDuWx8guX_KnuUCtWDZQ8WI',
  appId: '1:565979094510:web:cf51ee7acc454d663b42ff',
  messagingSenderId: '565979094510',
  projectId: 'kosfinder-p9',
  authDomain: 'kosfinder-p9.firebaseapp.com',
  storageBucket: 'kosfinder-p9.firebasestorage.app',
});

const messaging = firebase.messaging();

// Pesan "notification" otomatis ditampilkan oleh browser. Log ini untuk
// membuktikan pesan diterima di background.
messaging.onBackgroundMessage((payload) => {
  console.log('[BACKGROUND] Notification received', payload);
});
