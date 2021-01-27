<?php

declare(strict_types=1);

namespace DemoApp\PublicWeb;

use BackendBase\Shared\Interfaces\MezzioHandlerConfigProvider;
use DemoApp\PublicWeb\Contents\ConfigProvider as ContentsConfigProvider;
use DemoApp\PublicWeb\DemoModule\ConfigProvider as DemoModuleConfigProvider;
use DemoApp\PublicWeb\Forms\ConfigProvider as FormsConfigProvider;
use Mezzio\Application;
use Mezzio\MiddlewareFactory;

use function array_merge_recursive;

class ConfigProvider
{
    /** @var MezzioHandlerConfigProvider[] */
    private array $modules = [];

    public function __construct()
    {
        $this->addConfigProviders(new FormsConfigProvider());
        $this->addConfigProviders(new DemoModuleConfigProvider());
        $this->addConfigProviders(new ContentsConfigProvider()); // keep at the end of the stack
    }

    private function addConfigProviders(MezzioHandlerConfigProvider $configProvider): void
    {
        $this->modules[] = $configProvider;
    }

    public function __invoke(): array
    {
        return [
            'dependencies' => $this->getDependencies(),
            'templates'    => $this->getTemplates(),
            'module-name'  => 'FrontWeb',
        ];
    }

    public function registerRoutes(Application $app, MiddlewareFactory $factory): void
    {
        foreach ($this->modules as $module) {
            $module->registerRoutes($app, $factory);
        }
    }

    /**
     * Returns the container dependencies
     */
    public function getDependencies(): array
    {
        $dependencies = [];
        foreach ($this->modules as $module) {
            $dependencies = array_merge_recursive($dependencies, $module->getDependencies());
        }

        return $dependencies;
    }

    /**
     * Returns the templates configuration
     */
    public function getTemplates(): array
    {
      //  var_dump();exit();
        return [
            'paths' => [
                'app'    => ['src/templates/PublicWeb/app'],
                'error'  => ['src/templates/PublicWeb/error'],
                'layout' => ['src/templates/PublicWeb/layout'],
            ],
        ];
    }
}
