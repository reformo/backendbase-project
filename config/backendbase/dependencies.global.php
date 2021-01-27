<?php

declare(strict_types=1);

use Laminas\ServiceManager\Proxy\LazyServiceFactory;
use Doctrine\DBAL\Driver\Connection as DoctrineConnection;
use Doctrine\DBAL\Connection as DoctrineConnectionObject;
use Doctrine\ORM\EntityManager as DoctrineEntityManager;
use League\Tactician\CommandBus as TacticianCommandBus;
use BackendBase\Shared\Services\MessageBus\TacticianCommandBusFactory;
use BackendBase\Shared\Services\MessageBus\CommandBusFactory;
use BackendBase\Shared\Services\MessageBus\QueryBusFactory;
use BackendBase\Shared\Services\MessageBus\Interfaces\CommandBus;
use BackendBase\Shared\Services\MessageBus\Interfaces\QueryBus;
use BackendBase\Shared\Factory\Doctrine\ConnectionFactory;
use BackendBase\Shared\Factory\Doctrine\EntityManagerFactory;
use BackendBase\Shared\Factory\DoctrineRepositoryFactory;
use BackendBase\Shared\Factory\Filesystem\LocalFactory;
use BackendBase\Infrastructure\Persistence\Doctrine\Repository\GenericRepository;
use BackendBase\Infrastructure\Persistence\Doctrine\Repository\FileRepository;
use BackendBase\Infrastructure\Persistence\Doctrine\Repository\RolesRepository;
use BackendBase\Infrastructure\Persistence\Doctrine\Repository\ContentRepository;

use BackendBase\Domain\Collections;
use League\Flysystem\Filesystem;
use Psr\Log\LoggerInterface;
use BackendBase\Shared\Factory\AppLoggerFactory;
use BackendBase\Shared\Factory\LoggingErrorListenerDelegatorFactory;
use BackendBase\Domain\User\Interfaces\UserRepository;
use BackendBase\Shared\Factory\DomainRepositoryFactory;
use BackendBase\Shared\Middleware\PrivateApiAuthorizationMiddleware;
use BackendBase\Shared\Middleware\PrivateApiAuthorizationMiddlewareFactory;
use BackendBase\Shared\Middleware\CustomResponseHeadersMiddleware;
use BackendBase\Shared\Middleware\CustomResponseHeadersMiddlewareFactory;
use BackendBase\Shared\Middleware\LanguageSelectorMiddleware;
use BackendBase\Shared\Middleware\LanguageSelectorMiddlewareFactory;
use Redislabs\Module\ReJSON\ReJSON;
use RateLimit\RedisRateLimiter;
use BackendBase\Shared\Factory\RedisFactory;
use BackendBase\Shared\Factory\ReJSONFactory;
use BackendBase\Shared\Factory\RedisRateLimiterFactory;
use BackendBase\Shared\Middleware\CommandLogger;
use BackendBase\Shared\Middleware\CommandLoggerFactory;
use BackendBase\Domain\User\Interfaces\UserQuery;


return [
    'dependencies' => [
        'aliases' => [],
        'factories'  => [
            CustomResponseHeadersMiddleware::class => CustomResponseHeadersMiddlewareFactory::class,
            PrivateApiAuthorizationMiddleware::class => PrivateApiAuthorizationMiddlewareFactory::class,
            LanguageSelectorMiddleware::class => LanguageSelectorMiddlewareFactory::class,
            TacticianCommandBus::class => TacticianCommandBusFactory::class,
            CommandBus::class => CommandBusFactory::class,
            QueryBus::class => QueryBusFactory::class,
            CommandLogger::class => CommandLoggerFactory::class,
            LoggerInterface::class => AppLoggerFactory::class,
            Redis::class => RedisFactory::class,
            ReJSON::class => ReJSONFactory::class,
            RedisRateLimiter::class => RedisRateLimiterFactory::class,
            DoctrineConnection::class => ConnectionFactory::class,
            DoctrineEntityManager::class => EntityManagerFactory::class,
            GenericRepository::class => DoctrineRepositoryFactory::class,
            Collections\Interfaces\CollectionQuery::class => DoctrineRepositoryFactory::class,
            Collections\Interfaces\CollectionRepository::class => DoctrineRepositoryFactory::class,
            UserRepository::class => DomainRepositoryFactory::class,
            UserQuery::class => DomainRepositoryFactory::class,
            FileRepository::class =>  DoctrineRepositoryFactory::class,
            RolesRepository::class => DoctrineRepositoryFactory::class,
            ContentRepository::class => DoctrineRepositoryFactory::class,
            Filesystem::class => LocalFactory::class,
        ],
        'lazy_services' => [
            // Mapping services to their class names is required
            // since the ServiceManager is not a declarative DIC.
            'class_map' => [
                DoctrineConnection::class => DoctrineConnectionObject::class,
            ],
        ],
        'delegators' => [
            DoctrineConnection::class => [
                LazyServiceFactory::class,
            ],
            \Mezzio\ProblemDetails\ProblemDetailsMiddleware::class => [
                LoggingErrorListenerDelegatorFactory::class
            ]
        ],
    ],
];
