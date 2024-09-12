export const teamsDoc = {
  "/api/v1/teams": {
    post: {
      summary: "HMTX View",
      description:
        "Returns an html view with team from a particular league or an html error view.",
      requestBody: {
        required: true,
        content: {
          "application/x-www-form-urlencoded": {
            schema: {
              type: "object",
              properties: {
                league_id: {
                  type: "string",
                  description:
                    "A league_id is used to retrieve corresponding teams.",
                  example: "81fd5d4e-d500-413f-881d-6ec5cd2d5222",
                },
              },
              required: ["league_id"],
            },
          },
        },
      },
      responses: {
        200: {
          description: "A successful response",
          content: {
            "text/html": {
              schema: {
                type: "string",
                example: "<select><option>Atletico Madrid</option></select>",
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
                example: "<p>Unable to retrieve teams view. Try again.</p>",
              },
            },
          },
        },
      },
    },
  },
};
