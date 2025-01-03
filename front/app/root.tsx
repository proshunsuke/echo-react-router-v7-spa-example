import { ColorSchemeScript, LoadingOverlay } from "@mantine/core";
import { nprogress } from "@mantine/nprogress";
import { LayoutBody } from "app/components/layout/layoutBody";
import type React from "react";
import { useEffect } from "react";
import type { FC } from "react";
import {
	Links,
	Meta,
	Outlet,
	Scripts,
	ScrollRestoration,
	isRouteErrorResponse,
	useNavigation,
} from "react-router";
import type { Route } from "./+types/root.ts";

export const links: Route.LinksFunction = () => [
	{ rel: "preconnect", href: "https://fonts.googleapis.com" },
	{
		rel: "preconnect",
		href: "https://fonts.gstatic.com",
		crossOrigin: "anonymous",
	},
	{
		rel: "stylesheet",
		href: "https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap",
	},
	{
		rel: "icon",
		href: "/favicon.ico",
	},
];

export const Layout: FC<{ children: React.ReactNode }> = ({ children }) => {
	return (
		<html lang="ja">
			<head>
				<meta charSet="utf-8" />
				<meta name="viewport" content="width=device-width, initial-scale=1" />
				<Meta />
				<Links />
				<ColorSchemeScript />
			</head>
			<body>
				<LayoutBody>{children}</LayoutBody>
				<ScrollRestoration />
				<Scripts />
			</body>
		</html>
	);
};

const App: FC = () => {
	const navigation = useNavigation();
	useEffect(() => {
		if (navigation.state === "idle") {
			nprogress.complete();
		} else {
			nprogress.start();
		}
	}, [navigation.state]);
	return <Outlet />;
};

export default App;

export const ErrorBoundary: FC<Route.ErrorBoundaryProps> = ({ error }) => {
	let message = "Oops!";
	let details = "An unexpected error occurred.";
	let stack: string | undefined;

	if (isRouteErrorResponse(error)) {
		message = error.status === 404 ? "404" : "Error";
		details =
			error.status === 404
				? "The requested page could not be found."
				: error.statusText || details;
	} else if (import.meta.env.DEV && error && error instanceof Error) {
		details = error.message;
		stack = error.stack;
	}

	return (
		<main className="pt-16 p-4 container mx-auto">
			<h1>{message}</h1>
			<p>{details}</p>
			{stack && (
				<pre className="w-full p-4 overflow-x-auto">
					<code>{stack}</code>
				</pre>
			)}
		</main>
	);
};

export function HydrateFallback() {
	return <LoadingOverlay visible={true} />;
}
