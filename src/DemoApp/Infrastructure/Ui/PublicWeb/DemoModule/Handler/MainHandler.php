<?php

declare(strict_types=1);

namespace DemoApp\PublicWeb\DemoModule\Handler;

use BackendBase\Infrastructure\Persistence\Doctrine\Repository\ContentRepository;
use BackendBase\Shared\Services\MessageBus\Interfaces\QueryBus;
use Laminas\Diactoros\Response\HtmlResponse;
use Mezzio\Csrf\CsrfMiddleware;
use Mezzio\Template\TemplateRendererInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\RequestHandlerInterface;

class MainHandler implements RequestHandlerInterface
{
    private ?TemplateRendererInterface $template = null;
    private $config;
    private $queryBus;
    private ContentRepository $contentRepository;

    public function __construct(
        QueryBus $queryBus,
        TemplateRendererInterface $template,
        ContentRepository $contentRepository,
        array $config
    ) {
        $this->template          = $template;
        $this->config            = $config;
        $this->queryBus          = $queryBus;
        $this->contentRepository = $contentRepository;
    }

    public function handle(ServerRequestInterface $request): ResponseInterface
    {
        $guard = $request->getAttribute(CsrfMiddleware::GUARD_ATTRIBUTE);
        $token = $guard->generateToken();
        $slug  = [
            'tr' => '/modules/demo-modulu',
            'en' => '/modules/demo-module',
        ];
        $page  = $this->contentRepository->getContentBySlug(
            $slug[$request->getAttribute('selectedLanguage')],
            $request->getAttribute('selectedLanguage'),
            $request->getAttribute('selectedRegion')
        );

        $data = ['page' => $page];

        return new HtmlResponse($this->template->render('app::demo_module/main', $data));
    }
}
