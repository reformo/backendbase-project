
# Hexagonal (Ports and Adapters) Architecture and CQRS Ready Laminas Mezzio Skeleton.

An opinionated framework to develop CQRS applications using hexagonal architecture structure.

### Built on basically these libraries:
- Laminas Mezzio (Laminas ServiceManager, FastRoute, Twig)
- Tactician CommandBus by thephpleague.com
- Doctrine DBAL/ORM
- Redis ReJSON
- Symfony Console


### Coding standard
[Doctrine Coding Standart](https://github.com/doctrine/coding-standard) is used

## Installation
```bash
composer create-project reformo/backednbase-project MyApplication
```

## Development Server

### FrontWeb

```bash
composer run --timeout=0 start-public-web
```

### PrivateApi

```bash
composer run --timeout=0 start-private-api
```
