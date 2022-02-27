import PlayerTable from "./components/PlayerTable";
import Games from "./pages/Games";
import Home from "./pages/Home";
import League from "./pages/League";
import Leagues from "./pages/Leagues";
import Login from "./pages/Login";
import Match from "./pages/Match";
import Signup from "./pages/Signup";

// Any route which has a displayName will be displayed in the main navigation menu header.
export default [
  {
    path: "/",
    component: Home,
    name: "Home",
    displayName: "Home",
    meta: {
      title: "Home",
      public: true,
    },
  },
  { path: "/players", component: PlayerTable },
  { path: "/games", component: Games, displayName: "Games", name: "Games" },
  { path: "/games/:slug/leagues", component: Leagues, props: true, name: "GameLeagues" },
  { path: "/games/:game_slug/leagues/:league_slug", component: League, props: true, name: "League" },
  { path: "/match/:match_id", component: Match, props: true, name: "Match" },
  {
    path: "/login",
    component: Login,
    name: "Login",
    meta: {
      title: "Login",
      public: true,
    },
  },
  {
    path: "/signup",
    component: Signup,
    name: "Signup",
    meta: {
      title: "Sign up!",
      public: true,
    },
  },
];
