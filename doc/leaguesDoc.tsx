export const leaguesDoc = {
  "/api/v1/leagues": {
    get: {
      summary: "HMTX View",
      description:
        "Returns an html view with leagues array or an html error view.",
      responses: {
        200: {
          description: "A successful response",
          content: {
            "text/html": {
              schema: {
                type: "string",
                example: "<select><option>Liga MX</option></select>",
              },
            },
          },
        },
        500: {
          description: "A bad response",
          content: {
            "text/html": {
              schema: {
                type: "string",
                example: "<p>Unable to retrieve leagues view. Try again.</p>",
              },
            },
          },
        },
      },
    },
  },
};
