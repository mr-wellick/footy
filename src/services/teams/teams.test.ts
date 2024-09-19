import { afterEach, beforeEach, describe, it } from "node:test";
import assert from "node:assert";
import prisma from "../../db";
import sinon from "sinon";
import app from "../../app";

describe("Teams Controller", async () => {
  it("200: should return a view for teams, whether epmty or not.", async () => {
    const res = await app.request("/api/v1/teams", {
      method: "POST",
      body: new URLSearchParams({
        league_id: "81fd5d4e-d500-413f-881d-6ec5cd2d5222",
      }).toString(),
      headers: new Headers({
        "Content-Type": "application/x-www-form-urlencoded",
      }),
    });

    assert.strictEqual(200, res.status);
  });

  it("404: should return a zod error object", async () => {
    const res = await app.request("/api/v1/teams");

    assert.strictEqual(404, res.status);
  });
});

// read through some docs & examples to figure out how to do this right
describe("Teams Controller", () => {
  const originalFindMany = prisma.teams.findMany;
  beforeEach(() => {
    prisma.teams.findMany = sinon
      .stub(prisma.teams, "findMany")
      .rejects(new Error("Database Error"));
  });

  it("500: should returns an error view when db query fails", async () => {
    sinon.stub(prisma.teams, "findMany").rejects(new Error("Database Error"));

    const res = await app.request("/api/v1/teams", {
      method: "POST",
      body: new URLSearchParams({
        league_id: "81fd5d4e-d500-413f-881d-6ec5cd2d5222",
      }).toString(),
      headers: new Headers({
        "Content-Type": "application/x-www-form-urlencoded",
      }),
    });
    assert.equal(res.status, 500);
  });

  afterEach(() => {
    sinon.restore();
    prisma.teams.findMany = originalFindMany;
  });
});
