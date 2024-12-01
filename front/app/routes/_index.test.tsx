import type { FC } from "react";
import { createRoutesStub } from "react-router";
import { expect, test } from "vitest";
import { render } from "vitest-browser-react";
import { LayoutBody } from "~/components/layout/layoutBody";
import Index from "~/routes/_index";

test("render the home page", async () => {
	const Component: FC = () => (
		<LayoutBody>
			<Index />
		</LayoutBody>
	);
	const Stub = createRoutesStub([
		{
			path: "/",
			Component,
		},
	]);

	const { getByText } = render(<Stub initialEntries={["/"]} />);
	await expect.element(getByText("Hello, world!")).toBeInTheDocument();
});
