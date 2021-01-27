<?php
declare(strict_types=1);

return [
    'domain' => 'FrontWeb',
    'locale' => 'tr_TR',
    'plural-forms' => 'nplurals=2; plural=(n != 1);',
    'messages' => [
        '_LOCALE' => [
            'translate' => 'en_TR'
        ],
        '_LANG' => [
            'translate' => 'en-TR'
        ],
        '_REGION' => [
            'translate' => 'tr'
        ],
        '_DIR' => [
            'translate' => 'ltr'
        ],
        'HOME_PAGE_WELCOME_TO_S' => [
            'translate' => 'Welcome to %s',
            'reference' => 'Infrastructure/Ui/FormWeb/templates/app/home-page.html.twig',
            'comment' => 'Hero Welcome Message'
        ],
        'NUMBER_OF_USERS' => [
            'translate' => 'One user',
            'translate-plural' => '%d users',
            'reference' => 'Infrastructure/Ui/FormWeb/templates/app/home-page.html.twig',
            'comment' => 'Number of users'
        ],
        'NO_USERS' => [
            'translate' => 'No user atm.',
            'reference' => 'Infrastructure/Ui/FormWeb/templates/app/home-page.html.twig',
            'comment' => 'Number of users'
        ],
        'USER_LIST_HEADER' => [
            'translate' => 'User List',
            'reference' => 'Infrastructure/Ui/FormWeb/templates/app/home-page.html.twig',
        ],
    ]
];