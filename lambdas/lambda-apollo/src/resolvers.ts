import * as dotenv from 'dotenv';
import { InvokeCommand, LambdaClient, LogType } from '@aws-sdk/client-lambda';

dotenv.config()

const JsonToArray = (json) => {
	const str = JSON.stringify(json, null, 0);
	const ret = new Uint8Array(str.length);
	for (let i = 0; i < str.length; i++) {
		ret[i] = str.charCodeAt(i);
	}
	return ret
};

const lambdaInvoke = async ({ FunctionName, params }) => {
  const client = new LambdaClient({ region: 'us-east-1' });

  const command = new InvokeCommand({
    FunctionName,
    LogType: LogType.Tail,
    Payload: JsonToArray(params)
  });

  const { Payload } = await client.send(command);
  const result = Buffer.from(Payload).toString();
  const { body } = JSON.parse(result);
  return JSON.parse(body);
};

const pythonLambda = process.env.PYTHON_LAMBDA_ARN;

export const resolvers = {
  Query: {
    books: async () => {
      // const { payload } = process.env;
      // const { event } = JSON.parse(payload);

      return lambdaInvoke({ FunctionName: pythonLambda, params: {
        query: "getAllBooks"
      }});
    },
    book: async (_, { author, title }) => {
      let params;

      if (author) {
        params = {
          query: "getBookByAuthor",
          arg: author,
        }
      } else if (title) {
        params = {
          query: "getBookByTitle",
          arg: title
        }
      } else {
        return [];
      }

      return lambdaInvoke({ FunctionName: pythonLambda, params });
    },
  }
};
