// This is only for mixing js content like vue and others like scss

const mix = require("laravel-mix")

mix.js("resources/vue/main.js", "public/js/dist").vue();
mix.sass("resources/scss/main.scss", "public/css").vue();

mix.disableNotifications();