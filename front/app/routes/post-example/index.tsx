import {
	Button,
	Center,
	Container,
	Group,
	Paper,
	Stack,
	Text,
	TextInput,
	Title,
} from "@mantine/core";
import type { FC } from "react";
import { Form } from "react-router";
import { getPostExample, postPostExample } from "~/api/postExample";
import type { Route } from "./+types/index.ts";

export const meta = () => {
	return [{ title: "Post Example" }];
};

export const clientLoader = async ({
	params: _params,
}: Route.ClientLoaderArgs): Promise<{
	text: string;
}> => {
	return await getPostExample();
};

export type ClientActionResponseType = {
	data: string;
	error: string;
};

export const clientAction = async ({ request }: Route.ClientActionArgs) => {
	const formData = await request.formData();
	return await postPostExample(formData);
};

const PostExample: FC<
	Pick<Route.ComponentProps, "actionData" | "loaderData">
> = ({ actionData, loaderData }) => {
	const { text } = loaderData;
	return (
		<>
			<Container size={"lg"}>
				<Title order={1} ta="center">
					{text}
				</Title>
				<Paper shadow="xs" p="xl" withBorder={true} mt={"md"}>
					<Center>
						<Stack w={300}>
							<Form method="POST">
								<TextInput
									label={"post data"}
									name="postData"
									placeholder="please input post data"
									error={actionData?.error ? actionData.error : null}
								/>
								<Group justify="flex-end" mt="md">
									<Button type="submit">Submit</Button>
								</Group>
							</Form>
							{actionData?.data && (
								<Text>input post data: {actionData.data}</Text>
							)}
						</Stack>
					</Center>
				</Paper>
			</Container>
		</>
	);
};

export default PostExample;
