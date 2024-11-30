# Echo React Router v7 Example

## Demo

https://github.com/user-attachments/assets/b3e0ba9a-f46e-4a49-a692-ac48e51c5058

## Features

## Technologies

- [Go](https://go.dev/)
- [Echo](https://echo.labstack.com/)
- [React](https://react.dev/)
- [TypeScript](https://www.typescriptlang.org/)
- [React Router](https://reactrouter.com/)
- [Mantine](https://mantine.dev/)
- [Tailwind CSS](https://tailwindcss.com/)
- [Vite](https://vite.dev/)
- [Vitest](https://vitest.dev/)
- [Biome](https://biomejs.dev/)

## Technical Details

- Local development and production with Docker
- Hot reload (server-side and frontend)
- SPA
- File-convention based routing
- Validation
- Simple page
- Form request page
- Testing (frontend)

## Instruction

1. Launch app using docker compose

```bash
make compose/up
```

2. Access app

http://localhost:8080/

## Development

Rebuild docker image

```bash
make compose/build
```

Enter docker container

````bash
make shell/app
make shell/front
````

Run lint and format

```bash
make check
```

Run tests

```bash
make test
```

Simulate production environment

```bash
make compose/build/release
make compose/up/release
```
