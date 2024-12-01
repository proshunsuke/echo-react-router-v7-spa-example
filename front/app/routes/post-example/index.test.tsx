import { createRoutesStub } from "react-router";
import { expect, test } from "vitest";
import { render } from "vitest-browser-react";
import { LayoutBody } from "~/components/layout/layoutBody";
import PostExample from "~/routes/post-example/index";

test("render the post example page", async () => {
	const Component = () => {
		return (
			<LayoutBody>
				<PostExample loaderData={{ text: "text" }} />
			</LayoutBody>
		);
	};
	const Stub = createRoutesStub([
		{
			path: "/post-example",
			Component,
		},
	]);

	const { getByText } = render(<Stub initialEntries={["/post-example"]} />);
	await expect.element(getByText("text")).toBeInTheDocument();
});

test("render the post example page with action data", async () => {
	const Component = () => {
		return (
			<LayoutBody>
				<PostExample
					actionData={{ data: "this is data", error: "" }}
					loaderData={{ text: "text" }}
				/>
			</LayoutBody>
		);
	};
	const Stub = createRoutesStub([
		{
			path: "/post-example",
			Component,
		},
	]);

	const { getByText } = render(<Stub initialEntries={["/post-example"]} />);
	await expect.element(getByText("this is data")).toBeInTheDocument();
});

test("render the post example page with action error data", async () => {
	const Component = () => {
		return (
			<LayoutBody>
				<PostExample
					actionData={{ data: "", error: "this is error data" }}
					loaderData={{ text: "text" }}
				/>
			</LayoutBody>
		);
	};
	const Stub = createRoutesStub([
		{
			path: "/post-example",
			Component,
		},
	]);

	const { getByText } = render(<Stub initialEntries={["/post-example"]} />);
	await expect.element(getByText("this is error data")).toBeInTheDocument();
});
