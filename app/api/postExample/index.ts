import type { ClientActionResponseType } from "~/routes/post-example";

export const getPostExample = async (): Promise<{
	text: string;
}> => {
	const params = new URLSearchParams(window.location.search);
	const res = await fetch(`/api/post-example?${params.toString()}`);
	return await res.json();
};

export const postPostExample = async (
	formData: FormData,
): Promise<ClientActionResponseType> => {
	const result = await fetch("/api/post-example", {
		method: "POST",
		body: formData,
	});
	const json = (await result.json()) as {
		message: string;
		inputPostData: string;
	};
	if (!result.ok) {
		return { data: "", error: json.message };
	}
	return { data: json.inputPostData, error: "" };
};
