import {
	AppShell,
	Box,
	Burger,
	Flex,
	Group,
	NavLink as MantineNavLink,
	MantineProvider,
	createTheme,
} from "@mantine/core";
import { useDisclosure, useViewportSize } from "@mantine/hooks";
import { NavigationProgress } from "@mantine/nprogress";
import { IconHome2, IconShare3 } from "@tabler/icons-react";
import type React from "react";
import { type FC, useEffect } from "react";
import { NavLink } from "react-router";
import { LargeLogo } from "~/components/layout/largeLogo";
import { SmallLogo } from "~/components/layout/smallLogo";
import "~/app.css";
import "@mantine/core/styles.css";
import "@mantine/nprogress/styles.css";

const theme = createTheme({
	colors: {
		leeepGreen: [
			"#b6e8e5",
			"#6ed1ca",
			"#59cac3",
			"#4cc7bf",
			"#3bb0a8",
			"#2EA099",
			"#2d9c96",
			"#0e8882",
			"#0e807a",
			"#0d716b",
		],
	},
	primaryColor: "leeepGreen",
});

export const LayoutBody: FC<{ children: React.ReactNode }> = ({ children }) => {
	const [opened, { toggle, close, open }] = useDisclosure(true);
	const { width } = useViewportSize();
	useEffect(() => {
		width < 576 ? close() : open();
	}, [width, close, open]);
	return (
		<MantineProvider theme={theme}>
			<NavigationProgress />
			<AppShell
				layout={"alt"}
				header={{ height: 50 }}
				navbar={{
					width: opened ? 229 : 50,
					breakpoint: "0",
				}}
				padding="md"
			>
				<AppShell.Header>
					<Group h="100%">
						<Box className="border-r" p={"xs"} h="100%">
							<Burger opened={opened} onClick={toggle} size={"sm"} />
						</Box>
					</Group>
				</AppShell.Header>
				<AppShell.Navbar style={{ transition: "width 0.2s ease" }}>
					<Flex
						justify={"center"}
						align={"center"}
						h={"50px"}
						className={"border-b"}
					>
						{opened ? <LargeLogo /> : <SmallLogo />}
					</Flex>
					<nav>
						<MantineNavLink
							leftSection={<IconHome2 size={25} stroke={1.5} />}
							label={opened ? "Home" : ""}
							renderRoot={(props) => <NavLink to="/" {...props} />}
						/>
						<MantineNavLink
							leftSection={<IconShare3 size={25} stroke={1.5} />}
							label={opened ? "Post Example" : ""}
							renderRoot={(props) => <NavLink to="/post-example" {...props} />}
						/>
					</nav>
				</AppShell.Navbar>
				<AppShell.Main bg={"#ecf0f5"}>{children}</AppShell.Main>
			</AppShell>
		</MantineProvider>
	);
};
