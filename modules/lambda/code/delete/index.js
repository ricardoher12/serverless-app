'use strict';
var AWS = require("aws-sdk");

AWS.config.update({
  region: "us-west-2"
});

var ddb = new AWS.DynamoDB({apiVersion: '2012-08-10'});

exports.handler = function (event, context, callback) {
    var id = event.queryStringParameters.id;
    console.log(event.queryStringParameters);
    
    var params = {
        TableName: process.env.TABLE_NAME,
        Key: {
          'TeamId': {N: id}
        }
      };

      // Call DynamoDB to delete the item from the table
        ddb.deleteItem(params, function(err, data) {
            if (err) {
                console.log("Error", err);
                callback( null, {

                    statusCode: 500,
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: {
                        message: JSON.stringify(err, null, 2)
                    }
                });
            } else {
                console.log("Success", data);
                callback(null, {
                    statusCode: 200,
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify(data, null, 2)
                    });
            }
        });
}