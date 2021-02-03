<?php
declare(strict_types=1);

use BackendBase\Shared\Services\MessageBus\CommandHandlerFactory;
use BackendBase\Domain\Collections\Command\AddNewCollectionItemHandler;
use BackendBase\Domain\Collections\Command\UpdateCollectionItemHandler;
use BackendBase\Domain\Collections\Command\DeleteCollectionItemHandler;
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
            AddNewCollectionItemHandler::class => CommandHandlerFactory::class,
            UpdateCollectionItemHandler::class => CommandHandlerFactory::class,
            DeleteCollectionItemHandler::class => CommandHandlerFactory::class,
        ],
    ],
];
