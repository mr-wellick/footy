export const leaguesDoc = {
  "/api/v1/leagues": {
    get: {
      summary: "Leagues Controller",
      description: "Query leagues table.",
      responses: {
        200: {
          description: "A successful query to leagues table.",
          content: {
            "application/json": {
              schema: {
                type: "array",
                items: {
                  type: "object",
                  properties: {
                    league_id: {
                      type: "string",
                    },
                    league_name: {
                      type: "string",
                    },
                    country_id: {
                      type: "string",
                    },
                    division: {
                      type: "string",
                    },
                  },
                },
                example: [
                  {
                    league_id: "81fd5d4e-d500-413f-881d-6ec5cd2d5222",
                    league_name: "english premier league",
                    country_id: "c2eefade-d29b-4378-8c1c-53eae0283805",
                    division: "ENG.1",
                  },
                ],
              },
            },
          },
        },
        // TODO
        500: {
          description: "An unsuccessful query to leagues table.",
          content: {
            "application/json": {
              schema: {
                type: "array",
                properties: {},
                example: [],
              },
            },
          },
        },
      },
    },
  },
};
