import { afterEach, beforeEach, describe, it } from "node:test";
import assert from "node:assert";
import prisma from "../../db";
import sinon from "sinon";
import app from "../../app";

describe("Successful response", () => {
  it("200 status code: return drop down with all available leagues, if any ", async () => {
    const res = await app.request("api/v1/leagues");

    assert.strictEqual(200, res.status);
  });
});

describe("An unssuccesfull response", () => {
  // this is hella hacky. need to figure out how to do this properly
  const originalFindMany = prisma.leagues.findMany;
  beforeEach(() => {
    prisma.leagues.findMany = sinon
      .stub(prisma.leagues, "findMany")
      .rejects(new Error("Database error"));
  });

  it("500 status code: return an error view", async () => {
    const res = await app.request("api/v1/leagues");

    assert.equal(res.status, 500);
  });

  afterEach(() => {
    sinon.restore();
    prisma.leagues.findMany = originalFindMany;
  });
});
