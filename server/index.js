require('dotenv').config();
const express = require("express");
const nodemailer = require("nodemailer");
const cors = require("cors");
const app = express();
app.use(cors());
app.use(express.json());

const transporter = nodemailer.createTransport({
    service: "gmail",
    auth:{
        user: process.env.EMAIL,
        pass: process.env.PASS,
    }
});
app.post("/send-otp", async (req,res) =>{
    const {email, otp} = req.body;
    const mailOptions = {
        from: '"SecurePass" <codesavvy2@gmail.com>"',
        to: email,
        subject: "Your otp code",
        text: `Your OTP code is: ${otp}. It will expire in 5 minutes.`,

    };
    try {
        await transporter.sendMail(mailOptions);
        res.status(200).json({success : true});
    } catch (err) {
        console.error("Error sending email:", err);
    res.status(500).json({ success: false, error: err.message });
    }
});

app.listen(3000, () => {
  console.log("Server running on port 3000");
});