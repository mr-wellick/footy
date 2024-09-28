import { Hono } from "hono";
import prisma from "../../libs/prisma";
import { player_statistics } from "@prisma/client";

const app = new Hono();

app.post("/statistics", async (c) => {
  let result: player_statistics[] = [];

  try {
    const { team_id } = await c.req.json();
    result = await prisma.player_statistics.findMany({
      where: {
        team_id,
        season_id: "8b6ebde4-0bf9-4d0d-abe6-9eb2543fdb1d",
        // AND: [
        //   {
        //   },
        // ],
      },
    });
  } catch (error) {
    console.error(error);
    return c.json(result, 500);
  }

  return c.json(result, 200);
});

export default app;
