<?php
declare(strict_types=1);


use Twig\Extensions\IntlExtension;
use Twig\Extensions\TextExtension;
use Twig\Extensions\ArrayExtension;
use Twig\Extensions\DateExtension;
use Twig\Extensions\I18nExtension;

return [
    'twig' => [
        'autoescape' => 'html',
        'assets_url' => '',
        'assets_version' => getenv('ASSETS_VERSION'),
        'cache_dir' => getenv('ENABLE_TWIG_CACHE') == 'false' ? false : getenv('ENABLE_TWIG_CACHE'),
        'debug' =>  filter_var(getenv('ENABLE_TWIG_DEBUG'), FILTER_VALIDATE_BOOLEAN),
        'optimizations' => -1,
        'extensions' => [
            BackendBase\Shared\Services\TwigExtension::class,
            IntlExtension::class,
            //I18nExtension::class
            // Comment out extensions and invokable dependencies below when you need it
            // TextExtension::class,
            // ArrayExtension::class,
            // DateExtension::class,
        ],
        'globals' => [
            'cdnUrl' => getenv('BACKEND_CDN_URL')
        ],
        //'timezone' => 'Europe/London',
        'auto_reload' => filter_var(getenv('ENABLE_TWIG_AUTO_RELOAD'), FILTER_VALIDATE_BOOLEAN),
        //'runtime_loaders' => []
    ],
    'dependencies' => [
        'invokables' => [
            IntlExtension::class,
            //I18nExtension::class,
            // Comment out extensions below when you need it
            // TextExtension::class,
            // ArrayExtension::class,
            // DateExtension::class,
        ],
    ]
];