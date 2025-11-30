import 'question_model.dart';
import 'it_questions.dart';
import 'core_questions.dart';
import 'sales_questions.dart';
import 'bpo_questions.dart';
import 'industry_category.dart';


/// Enum for the four industries you support.

class QuestionBankRepository {
  static List<QuestionItem> forIndustry(IndustryCategory industry) {
    switch (industry) {
      case IndustryCategory.it:
        return itQuestions;
      case IndustryCategory.core:
        return coreQuestions;
      case IndustryCategory.sales:
        return salesQuestions;
      case IndustryCategory.bpo:
        return bpoQuestions;
    }
  }

  static List<IndustryCategory> get allIndustries =>
      IndustryCategory.values;
}
