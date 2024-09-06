import { Hono } from "hono";
import prisma from "../../db";
import { teams } from "@prisma/client";
import { FC } from "hono/jsx";
import { zValidator } from "@hono/zod-validator";
import { z } from "zod";

const app = new Hono();

const View: FC<{ teams: teams[] }> = ({ teams }) => {
  if (teams.length <= 0) return <p>No teams for selected leagues</p>;

  return (
    <ul>
      {teams.map((team) => (
        <li>{team.team_name}</li>
      ))}
    </ul>
  );
};

app.post(
  "/",
  zValidator(
    "header",
    z.object({
      "content-type": z
        .string()
        .refine((value) => value === "application/x-www-form-urlencoded", {
          message: "Content-Type must be application/x-www-form-urlencoded",
        }),
    })
  ),
  async (c) => {
    let result: teams[] = [];
    try {
      const form = await c.req.formData();
      result = await prisma.teams.findMany({
        where: { team_league_id: form.get("team_league_id") as string },
      });
    } catch (error) {
      console.log(error);
      return c.json({ message: "you don' goofed" });
    }

    return c.html(<View teams={result} />);
  }
);

export default app;
