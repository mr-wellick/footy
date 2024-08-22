import { PrismaClient } from "@prisma/client";
import { Hono } from "hono";

const prisma = new PrismaClient();
const app = new Hono();

app.get("/countries", async (c) => {
  const countries = await prisma.country_codes.create({
    data: {
      country_code: "",
      country_name: "",
    },
  });
  return c.json(countries, 200);
});

export default app;
