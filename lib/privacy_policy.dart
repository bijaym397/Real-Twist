import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade800,
        title: const Text("Real Twist Privacy Policy"),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: const [
          Text(
            "This Privacy Policy informs you of our policies regarding the collection, use, and disclosure of personal information we receive from users of the Real Twist App.",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          TextCommon(
              text: "Information Collection and Use",
              size: 22,
              isIcon: false,
              topPadding: 24),
          TextCommon(text: "User-Provided Information: ", size: 22),
          TextCommon(
            text:
                "The App may collect personal information that you provide voluntarily when you register, make in-app purchases, or otherwise use the App. This information may include, but is not limited to, your name, email address, and payment information.",
            isIcon: false,
            size: 18,
            leftSpace: 22,
          ),
          TextCommon(text: "Automatically Collected Information:", size: 22),
          TextCommon(
            text:
                "We may collect information about your device and usage of the App automatically. This may include your device type, operating system, IP address, and in-app activities.",
            isIcon: false,
            size: 18,
            leftSpace: 22,
          ),

          ///
          TextCommon(
            text: "Use of Collected Information",
            size: 22,
            isIcon: false,
            topPadding: 24,
          ),
          TextCommon(
              text:
                  "We may use the information we collect for various purposes, including but not limited to:",
              isIcon: false,
              size: 22),
          TextCommon(
            text: "Providing, maintaining, and improving the App.",
            size: 18,
            leftSpace: 22,
          ),
          TextCommon(
            text: "Providing, maintaining, and improving the App.",
            size: 18,
            leftSpace: 22,
          ),
          TextCommon(
            text: "Personalizing your experience within the App.",
            size: 18,
            leftSpace: 22,
          ),
          TextCommon(
            text: "Processing transactions, including in-app purchases.",
            size: 18,
            leftSpace: 22,
          ),
          TextCommon(
            text: "Responding to your customer service requests.",
            size: 18,
            leftSpace: 22,
          ),
          TextCommon(
            text: "Sending you promotional and marketing communications.",
            size: 18,
            leftSpace: 22,
          ),

          ///
          TextCommon(
            text: "Data Security",
            size: 22,
            isIcon: false,
            topPadding: 24,
          ),
          TextCommon(
              text:
              "The security of your personal information is important to us, but please be aware that no method of transmission over the internet or electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your personal information, we cannot guarantee its absolute security.",
              isIcon: false,
              topPadding: 4,
              size: 20,),
          ///
          TextCommon(
            text: "Third-Party Services",
            size: 22,
            isIcon: false,
            topPadding: 24,
          ),
          TextCommon(
              text:
              "The App may use third-party services, such as analytics and advertising providers. These third parties may have access to your personal information as needed to perform their functions, but they are not permitted to share or use the information for any other purpose.",
              isIcon: false,
              topPadding: 4,
              size: 20,),
          ///
          TextCommon(
            text: "Children's Privacy",
            size: 22,
            isIcon: false,
            topPadding: 24,
          ),
          TextCommon(
              text:
              "The App is not intended for use by children under the age of 13. We do not knowingly collect personal information from children under 13. If you are a parent or guardian and become aware that your child has provided us with personal information, please contact us, and we will take steps to remove that information.",
              isIcon: false,
              topPadding: 4,
              size: 20,),
          ///
          TextCommon(
            text: "Changes to This Privacy Policy",
            size: 22,
            isIcon: false,
            topPadding: 24,
          ),
          TextCommon(
              text:
              "We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes.",
              isIcon: false,
              topPadding: 4,
              size: 20,),
          ///
          TextCommon(
            text: "Changes to This Privacy Policy",
            size: 22,
            isIcon: false,
            topPadding: 24,
          ),
          TextCommon(
              text:
              "We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes.",
              isIcon: false,
              topPadding: 4,
              size: 20,),
          ///
          TextCommon(
            text: "Contact Us",
            size: 22,
            isIcon: false,
            topPadding: 24,
          ),
          TextCommon(
              text:
              "If you have any questions or concerns about this Privacy Policy, please contact us at bijay.primotech@gmail.com.",
              isIcon: false,
              topPadding: 4,
              size: 20,),
        ],
      ),
    );
  }
}

class TextCommon extends StatelessWidget {
  const TextCommon(
      {Key? key,
      this.text,
      this.size,
      this.isIcon = true,
      this.topPadding,
      this.leftSpace,
      this.align})
      : super(key: key);
  final String? text;
  final double? size;
  final double? topPadding;
  final double? leftSpace;
  final bool? isIcon;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding ?? 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isIcon == true
              ? const Icon(Icons.arrow_circle_right)
              : SizedBox(width: leftSpace ?? 0),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text ?? "",
              style:
                  TextStyle(fontWeight: FontWeight.w600, fontSize: size ?? 20),
              textAlign: align ?? TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
