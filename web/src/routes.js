import PlayerTable from "./components/PlayerTable";
import Games from "./pages/Games";
import Home from "./pages/Home";
import Leagues from "./pages/Leagues";
import Login from "./pages/Login";
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
  { path: "/players", component: PlayerTable, displayName: "Players" },
  { path: "/games", component: Games, displayName: "Games" },
  { path: "/games/:slug/leagues", component: Leagues, props: true },
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
