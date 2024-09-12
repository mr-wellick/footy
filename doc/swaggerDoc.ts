import { leaguesDoc } from "./leaguesDoc";
import { teamsDoc } from "./teamsDoc";

export const swaggerDoc = {
  openapi: "3.0.0",
  info: {
    title: "Footballers API",
    version: "1.0.0",
    description: "An API to visualize football data.",
  },
  servers: [
    {
      url: "http://localhost:3000",
    },
  ],
  paths: {
    ...leaguesDoc,
    ...teamsDoc,
  },
};
