<?php

declare(strict_types=1);

namespace DemoApp\PrivateApi\DemoModule\Handler;

use BackendBase\Domain\IdentityAndAccess\Exception\InsufficientPrivileges;
use BackendBase\Infrastructure\Persistence\Doctrine\Repository\GenericRepository;
use BackendBase\Shared\Services\PayloadSanitizer;
use Laminas\Diactoros\Response\EmptyResponse;
use Laminas\Permissions\Rbac\Role;
use DemoApp\Domain\IdentityAndAccess\Model\Permissions;
use DemoApp\Infrastructure\Persistence\Doctrine\Entity\DemoModuleEntity;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\RequestHandlerInterface;
use const ARRAY_FILTER_USE_KEY;
use function array_filter;
use function in_array;

class ChangeItem implements RequestHandlerInterface
{
    private GenericRepository $genericRepository;

    public function __construct(
        GenericRepository $genericRepository
    ) {
        $this->genericRepository = $genericRepository;
    }

    public function handle(ServerRequestInterface $request) : ResponseInterface
    {
        /**
         * @var Role
         */
        $role = $request->getAttribute('role');
        if ($role->hasPermission(Permissions\DemoModule::DEMO_MODULE_MENU) === false) {
            throw InsufficientPrivileges::create('You dont have privilege to change demo module records');
        }
        $payload     = PayloadSanitizer::sanitize($request->getParsedBody());
        $allowedKeys = ['region', 'name', 'image',  'isVisible', 'isDeleted'];
        $payload     = array_filter($payload, static function ($key) use ($allowedKeys) {
            return in_array($key, $allowedKeys, true);
        }, ARRAY_FILTER_USE_KEY);
        $id          = $request->getAttribute('itemId');
        $this->genericRepository->updateGeneric(NeredeSatilir::class, $id, $payload);

        return new EmptyResponse(204);
    }
}
