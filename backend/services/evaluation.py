"""
Evaluation Service
Uses Hermes vision model to evaluate documents
"""

from typing import Optional
import json

from models.evaluation import EvaluationRequest, EvaluationResult


class EvaluationService:
    def __init__(self):
        # In a real implementation, this would connect to Hermes
        # For now, we'll use a simple rule-based evaluation
        pass
    
    async def evaluate(self, request: EvaluationRequest) -> EvaluationResult:
        """
        Evaluate a document against task criteria.
        
        This service:
        1. Analyzes the document content (text or image)
        2. Checks against task requirements
        3. Returns approval/rejection with feedback
        """
        
        # Get task details to know what we're evaluating against
        # For now, use basic heuristics
        
        if request.text_content:
            return await self._evaluate_text(request)
        elif request.file_content:
            return await self._evaluate_file(request)
        else:
            return EvaluationResult(
                status="rejected",
                feedback="No content provided for evaluation",
                score=0.0
            )
    
    async def _evaluate_text(self, request: EvaluationRequest) -> EvaluationResult:
        """Evaluate text content"""
        text = request.text_content or ""
        
        # Basic quality checks
        score = 0.0
        feedback_parts = []
        improvements = []
        
        # Length check
        if len(text) < 100:
            feedback_parts.append("Your submission is too short")
            improvements.append("Aim for at least 500 words for a complete response")
            score += 0.1
        elif len(text) < 300:
            feedback_parts.append("Your submission could be more detailed")
            improvements.append("Expand your response with more specific examples")
            score += 0.3
        else:
            score += 0.5
        
        # Structure check
        paragraphs = text.split('\n\n')
        if len(paragraphs) >= 3:
            score += 0.2
            feedback_parts.append("Good structure with multiple paragraphs")
        else:
            improvements.append("Organize your response into clear paragraphs")
        
        # Vocabulary richness (simple check)
        words = text.split()
        unique_words = set(words)
        if len(unique_words) / max(len(words), 1) > 0.6:
            score += 0.2
            feedback_parts.append("Good vocabulary variety")
        else:
            improvements.append("Try using more varied vocabulary")
        
        # Specificity check (presence of examples, numbers, etc.)
        if any(char.isdigit() for char in text):
            score += 0.1
            feedback_parts.append("Good use of specific data/numbers")
        
        # Determine approval
        status = "approved" if score >= 0.6 else "rejected"
        
        # Build feedback
        feedback = ". ".join(feedback_parts) if feedback_parts else "Your submission meets the basic requirements."
        
        if status == "rejected":
            feedback = f"While your effort shows promise, there are areas for improvement: {feedback}"
            if improvements:
                feedback += " Key areas to focus on: " + ". ".join(improvements[:2])
        
        return EvaluationResult(
            status=status,
            feedback=feedback,
            score=score,
            improvements=improvements if improvements else None,
            file_type=request.file_type,
            filename=request.filename
        )
    
    async def _evaluate_file(self, request: EvaluationRequest) -> EvaluationResult:
        """Evaluate file content (PDF, image, etc.)"""
        # For images/PDFs, we would use Hermes vision model
        # For now, return a basic evaluation
        
        return EvaluationResult(
            status="approved",
            feedback="Document received and under review. Your submission has been logged.",
            score=0.7,
            file_type=request.file_type,
            filename=request.filename
        )
    
    async def evaluate_with_hermes(self, request: EvaluationRequest) -> EvaluationResult:
        """
        Full Hermes evaluation (for when Hermes is integrated)
        
        This would:
        1. Send the document to Hermes vision model
        2. Get detailed analysis
        3. Return structured feedback
        """
        # Placeholder for Hermes integration
        # When Hermes is embedded in the app, this will:
        # - Use vision model for images/PDFs
        # - Use language model for text
        # - Return detailed, constructive feedback
        
        return await self.evaluate(request)
