<?php

    return [

        // Panel Credential
        'username'          => env('GITANDO_USERNAME', 'admin'),
        'password'          => env('GITANDO_PASSWORD', 'changethis'),

        // JWT Settings
        'jwt_secret'        => env('JWT_SECRET', env('APP_KEY')),
        'jwt_access'        => env('JWT_ACCESS', 900),
        'jwt_refresh'       => env('JWT_REFRESH', 7200),

        // Custom Vars
        'name'              => env('GITANDO_NAME', 'Gitando Control Panel'),
        'website'           => env('GITANDO_WEBSITE', 'https://gitando.com'),
        'activesetupcount'  => env('GITANDO_ACTIVESETUPCOUNT', 'https://service.gitando.com/setupcount'),
        'documentation'     => env('GITANDO_DOCUMENTATION', 'https://gitando.com/docs.html'),
        'app'               => env('GITANDO_APP', 'https://play.google.com/store/apps/details?id=it.christiangiupponi.gitando'),

        // Global Settings
        'users_prefix'      => env('GITANDO_USERS_PREFIX', 'gtd'),
        'phpvers'           => ['8.1','8.0','7.4'],
        'services'          => ['nginx','php','mysql','redis','supervisor'],
        'default_php'       => '8.0',

    ];
