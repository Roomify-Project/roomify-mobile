class AddCommentBody {
  final String content;
  final String portfolioPostId;

  AddCommentBody({
    required this.content,
    required this.portfolioPostId,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'PortfolioPostId': portfolioPostId,
    };
  }
}
