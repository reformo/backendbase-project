<?php

declare(strict_types=1);

namespace DemoApp\PublicWeb\Forms;

use BackendBase\PublicWeb\Forms\SaveFormData;
use BackendBase\Shared\Factory\RequestHandlerFactory;
use BackendBase\Shared\Interfaces\MezzioHandlerConfigProvider;
use Mezzio\Application;
use Mezzio\MiddlewareFactory;

/**
 * The configuration provider for the App module
 *
 * @see https://docs.zendframework.com/zend-component-installer/
 */
class ConfigProvider implements MezzioHandlerConfigProvider
{
    /**
     * Returns the configuration array
     *
     * To add a bit of a structure, each section is defined in a separate
     * method which returns an array with its configuration.
     */
    public function __invoke() : array
    {
        return [
            'dependencies' => $this->getDependencies(),
        ];
    }

    public function registerRoutes(Application $app, MiddlewareFactory $factory) : void
    {
        $app->get('/contact', Handler\ContactForm::class, 'contact.form');
        $app->post('/contact', SaveFormData::class, 'contact.save');
    }

    /**
     * Returns the container dependencies
     */
    public function getDependencies() : array
    {
        return [
            'invokables' => [],
            'factories'  => [
                Handler\ContactForm::class => RequestHandlerFactory::class,
                SaveFormData::class => RequestHandlerFactory::class,
            ],
        ];
    }
}
