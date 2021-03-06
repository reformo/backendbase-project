<?php

declare(strict_types=1);

namespace DemoApp\PublicWeb\Forms\Handler;

use BackendBase\Infrastructure\Persistence\Doctrine\Repository\ContentRepository;
use Laminas\Diactoros\Response\HtmlResponse;
use Mezzio\Csrf\CsrfMiddleware;
use Mezzio\Template\TemplateRendererInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\RequestHandlerInterface;

class ContactForm implements RequestHandlerInterface
{
    private ?TemplateRendererInterface $template = null;
    private ContentRepository $contentRepository;

    public function __construct(
        TemplateRendererInterface $template,
        ContentRepository $contentRepository
    ) {
        $this->template          = $template;
        $this->contentRepository = $contentRepository;
    }

    public function handle(ServerRequestInterface $request): ResponseInterface
    {
        $guard       = $request->getAttribute(CsrfMiddleware::GUARD_ATTRIBUTE);
        $token       = $guard->generateToken();
        $queryParams = $request->getQueryParams();
        $result      = $queryParams['r'] ?? '';
        $message     = $queryParams['m'] ?? '';

        $data = [
            '__csrf' => $token,
            'result' => $result,
            'message' => $message,
            'queryParams' => $queryParams,
        ];

        return new HtmlResponse($this->template->render('app::forms/contact-form', $data));
    }
}
