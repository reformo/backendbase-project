<?php

declare(strict_types=1);

namespace DemoApp\PrivateApi\DemoModule\Handler;

use BackendBase\Domain\IdentityAndAccess\Exception\InsufficientPrivileges;
use DemoApp\Domain\IdentityAndAccess\Model\Permissions;
use Laminas\Diactoros\Response\JsonResponse;
use Laminas\Permissions\Rbac\Role;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\RequestHandlerInterface;

use function ceil;
use function file_get_contents;
use function json_decode;

class ItemsList implements RequestHandlerInterface
{
    private NeredeSatilirRepository $repository;

    public function __construct(
        NeredeSatilirRepository $repository
    ) {
        $this->repository = $repository;
    }

    public function handle(ServerRequestInterface $request): ResponseInterface
    {
        /**
         * @var Role
         */
        $role = $request->getAttribute('role');
        if ($role->hasPermission(Permissions\DemoModule::DEMO_MODULE_MENU) === false) {
            throw InsufficientPrivileges::create('You dont have privilege to list demo module records');
        }

        $limit       = 25;
        $queryParams = $request->getQueryParams();
        $page        = $queryParams['page'] ?? 1;
        $total       = $this->repository->getTotal();
        $pageCount   = ceil($total / $limit);
        if ($page > $pageCount) {
            $page = $pageCount;
        }

        if ($page < 1) {
            $page = 1;
        }

        $offset = $limit * ($page - 1);
        $cities = json_decode(file_get_contents('src/config/cities.json'), true);

        return new JsonResponse([
            'neredeSatilir' => $this->repository->getList($offset, $limit),
            'pageSize' => $limit,
            'total' => $total,
            'page' => $page,
            'cities' => $cities,
        ]);
    }
}
