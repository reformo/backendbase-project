<?php
declare(strict_types=1);

use BackendBase\Shared\Services\MessageBus\CommandHandlerFactory;
use BackendBase\Domain\Collections;
use BackendBase\Domain\User;
return [

    'dependencies' => [
        'aliases' => [
            // Fully\Qualified\ClassOrInterfaceName::class => Fully\Qualified\ClassName::class,
        ],

        'invokables' => [
            // Fully\Qualified\InterfaceName::class => Fully\Qualified\ClassName::class,
        ],
        'factories'  => [
        //    Command::class => CommandHandlerFactory::class
            Collections\Query\GetCollectionItemByIdHandler::class => CommandHandlerFactory::class,
            Collections\Query\GetCollectionItemByKeyHandler::class => CommandHandlerFactory::class,
            Collections\Query\GetCollectionItemBySlugHandler::class => CommandHandlerFactory::class,
            Collections\Query\GetCollectionItemsHandler::class => CommandHandlerFactory::class,
            User\Query\GetAllUsersHandler::class => CommandHandlerFactory::class,
        ],
    ],
];
