const express = require("express");
const { Sequelize, DataTypes } = require("sequelize");
const { configDotenv } = require("dotenv");
require("dotenv").config();

const app = express();
const Port = process.env.PORT || 3000;

app.use(express.json({limit: "10kb"}));

const sequelize = new Sequelize(process.env.URL, {
    dialect: "postgres",
    dialectOptions: {
        ssl: {
            require: true,
            rejectUnauthorized: false,
        },
    },

    logging: false
})

sequelize.sync().then(() => { console.log(`Connected`) }).catch((err) => { console.log(err) });

const post = sequelize.define("godotDatabase", {
    Username: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    Round: {
        type: DataTypes.INTEGER,
        allowNull: false,
    }
})

app.get("/", (req, res) => {
    res.json({msg: "database running"})
})

app.get("/leaderboard", async (req, res) => {
    try {
        const Top10 = await post.findAll({
            attributes: ["Username", "Round"],
            order: [["Round", "DESC"]],
            limit: 10,
        })

        console.log(Top10)

        res.json(Top10.map((user)=>({
            name: user.Username, 
            round: user.Round,
        })))
    } catch (err){
        console.log(err)
        res.json({err: "true"})
    }
})

app.post("/submit", async (req, res) => {
    try {
    const { Username, Round } = req.body
    var username = Username || "anonymous"
    console.log(Round)
    const NewPost = await post.create({ Username: username, Round });
    res.json({outcome: true})}
    catch (err){
        console.log(err)
        res.json({outcome: false})
    }
})

async function startServer() {
    try {
        await sequelize.authenticate();
        await sequelize.sync();
        app.listen(Port, () => {
            console.log(`Listening on port ${Port}`);
        });
    } catch (err) {
        console.error("Database connection failed:", err);
        process.exit(1);
    }
}

startServer();