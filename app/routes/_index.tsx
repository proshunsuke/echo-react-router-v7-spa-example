import { Title } from "@mantine/core";
import type { FC } from "react";

export const meta = () => {
	return [{ title: "Home" }];
};

const Index: FC = () => (
	<Title order={1} ta="center">
		Hello, world!
	</Title>
);

export default Index;
