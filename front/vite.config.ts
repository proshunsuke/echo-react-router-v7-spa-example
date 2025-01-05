import { reactRouter } from "@react-router/dev/vite";
import autoprefixer from "autoprefixer";
import tailwindcss from "tailwindcss";
import { defineConfig } from "vite";
import tsconfigPaths from "vite-tsconfig-paths";

const isTest = process.env.NODE_ENV === "test";

export default defineConfig({
	css: {
		postcss: {
			plugins: [tailwindcss, autoprefixer],
		},
	},
	server: {
		open: "http://localhost:8080/",
	},
	plugins: [isTest ? null : reactRouter(), tsconfigPaths()],
	optimizeDeps: {
		include: [
			"@mantine/hooks",
			"@mantine/nprogress",
			"@tabler/icons-react",
			"react",
			"react/jsx-dev-runtime",
		],
	},
});
