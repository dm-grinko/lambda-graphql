import { ApolloServer } from "@apollo/server";
import { startStandaloneServer } from "@apollo/server/standalone";

import { typeDefs } from './typeDefs.js';
import { resolvers } from './resolvers.js';

const server = new ApolloServer({
  typeDefs,
  resolvers
});

const init = (async () => {
    const { url } = await startStandaloneServer(server, {
        listen: { port: 4000 }
    });

    console.log(url);
})

init();
