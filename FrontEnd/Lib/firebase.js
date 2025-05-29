// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyDHkxG67ENhfHJhUVER3ldIi9XOjU2-nc0",
  authDomain: "organicfarming3-f95bc.firebaseapp.com",
  projectId: "organicfarming3-f95bc",
  storageBucket: "organicfarming3-f95bc.firebasestorage.app",
  messagingSenderId: "1056609215323",
  appId: "1:1056609215323:web:020bf04971021c19f6707e",
  measurementId: "G-M57PF2ZPBV"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);