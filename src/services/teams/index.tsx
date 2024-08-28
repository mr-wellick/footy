import { Hono } from "hono";
import prisma from "../../db";
import { teams } from "@prisma/client";
import { FC } from "hono/jsx";

const app = new Hono();

const View: FC<{ teams: teams[] }> = ({ teams }) => {
  return (
    <ul>
      {teams.map((team) => (
        <li>{team.team_name}</li>
      ))}
    </ul>
  );
};

app.post("/", async (c) => {
  let result: teams[] = [];
  try {
    const body = await c.req.parseBody();
    result = await prisma.teams.findMany({
      where: { league_id: body.league_id },
    });
  } catch (error) {
    return c.json({ message: "you don' goofed" });
  }

  return c.html(<View teams={result} />);
});

export default app;
