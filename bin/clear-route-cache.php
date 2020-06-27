<?php
/**
 * Script for clearing the configuration cache.
 *
 * Can also be invoked as `composer clear-config-cache`.
 *
 * @see       https://github.com/mezzio/mezzio-skeleton for the canonical source repository
 */

declare(strict_types=1);

chdir(__DIR__ . '/../');

$routeFiles = glob('data/cache/*-route.php.cache');

if (count($routeFiles) === 0) {
    echo 'No route cache path found' . PHP_EOL;
    exit(0);
}
foreach ($routeFiles as $routeFile) {
    if (! file_exists($routeFile)) {
        printf(
            "Configured route cache file '%s' not found%s",
            $routeFile,
            PHP_EOL
        );
        exit(0);
    }

    if (unlink($routeFile) === false) {
        printf(
            "Error removing route cache file '%s'%s",
            $routeFile,
            PHP_EOL
        );
        exit(1);
    }

    printf(
        "Removed configured route cache file '%s'%s",
        $routeFile,
        PHP_EOL
    );
}
exit(0);
