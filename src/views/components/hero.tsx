import { FC, useEffect, useState } from "hono/jsx";

const DataFilter: FC = () => {
  return (
    <div className="flex flex-col">
      <form
        className="join"
        onChange={(e) => {
          if (e.target) {
            let el = e.target as HTMLFormElement;
            console.log(el.ariaLabel);
          }
        }}
      >
        <input
          className="join-item btn"
          type="radio"
          name="options"
          aria-label="Teams"
          checked
        />
        <input
          className="join-item btn"
          type="radio"
          name="options"
          aria-label="Players"
        />
      </form>
      <div className="flex">
        <div class="badge badge-neutral">EPL</div>
        <div class="badge badge-primary">Arsenal</div>
        <div class="badge badge-secondary">2023-2034</div>
      </div>
      <select className="select select-accent w-full max-w-xs">
        <option disabled selected>
          Dark mode or light mode?
        </option>
        <option>Auto</option>
        <option>Dark mode</option>
        <option>Light mode</option>
      </select>
    </div>
  );
};

const Leagues: FC = () => {
  const [data, setData] = useState([]);

  useEffect(() => {
    fetch("http://localhost:3000/api/v1/leagues")
      .then((res) => res.json())
      .then((data) => setData(data))
      .catch((error) => console.log(error));
  }, [data]);

  return (
    <select
      className="select select-primary w-full max-w-xs"
      onChange={(e) => {
        fetch("http://localhost:3000/api/v1/teams", {
          method: "POST",
          body: JSON.stringify({
            league_id: e.target.value,
          }),
        })
          .then((res) => res.json())
          .then((data) => console.log(data))
          .catch((error) => console.log(error));
      }}
    >
      <option disabled selected>
        choose a league
      </option>
      {data.map((league) => {
        return <option value={league.league_id}>{league.league_name}</option>;
      })}
    </select>
  );
};

const Hero: FC = () => {
  return (
    <div className="flex">
      <div className="hero bg-base-200 min-h-screen">
        <div className="hero-content">
          <Leagues />
          <div>
            <h1 className="text-5xl font-bold">Box Office News!</h1>
            <p className="py-6">
              Provident cupiditate voluptatem et in. Quaerat fugiat ut assumenda
              excepturi exercitationem quasi. In deleniti eaque aut repudiandae
              et a id nisi.
            </p>
            <button className="btn btn-primary">Get Started</button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Hero;
