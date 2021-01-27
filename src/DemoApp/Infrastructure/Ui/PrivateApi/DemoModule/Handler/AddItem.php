<?php

declare(strict_types=1);

namespace DemoApp\PrivateApi\DemoModule\Handler;

use BackendBase\Domain\IdentityAndAccess\Exception\InsufficientPrivileges;
use BackendBase\Infrastructure\Persistence\Doctrine\Repository\GenericRepository;
use BackendBase\Shared\Services\PayloadSanitizer;
use DateTimeImmutable;
use DemoApp\Domain\IdentityAndAccess\Model\Permissions;
use Laminas\Diactoros\Response\EmptyResponse;
use Laminas\Permissions\Rbac\Role;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Ramsey\Uuid\Uuid;

class AddItem implements RequestHandlerInterface
{
    private GenericRepository $genericRepository;

    public function __construct(
        GenericRepository $genericRepository
    ) {
        $this->genericRepository = $genericRepository;
    }

    public function handle(ServerRequestInterface $request): ResponseInterface
    {
        /**
         * @var Role
         */
        $role = $request->getAttribute('role');
        if ($role->hasPermission(Permissions\DemoModule::DEMO_MODULE_MENU) === false) {
            throw InsufficientPrivileges::create('You dont have privilege to add demo module records');
        }

        $payload = PayloadSanitizer::sanitize($request->getParsedBody());

        $item = new NeredeSatilir();
        $item->setId(Uuid::uuid4()->toString());
        $item->setRegion($payload['region']);
        $item->setName($payload['name']);
        $item->setImage($payload['image']);
        $item->setIsVisible(1);
        $item->setIsDeleted(0);
        $item->setCreatedAt(new DateTimeImmutable());
        $this->genericRepository->persistGeneric($item);

        return new EmptyResponse(204, ['BackendBase-Insert-Id' => $item->id()]);
    }
}
