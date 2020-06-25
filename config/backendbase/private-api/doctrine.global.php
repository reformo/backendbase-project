<?php
declare(strict_types=1);


return [
    'doctrine' => [
        'dbal' => [
            'url' => 'postgres://' . getenv('PG_USERNAME') . ':' . getenv('PG_PASSWORD')
                . '@' . getenv('PG_HOST') . '/' . getenv('PG_DBNAME'),
            'db_name' =>  getenv('PG_DBNAME'),
            'driverOptions' => [
                PDO::ATTR_EMULATE_PREPARES => false
            ]
        ],
        'namespace' => '\\BackendBase\\Infrastructure\\Persistence\\Doctrine',
        'namespace-for-generator' => 'BackendBase\\Doctrine'
    ]
];